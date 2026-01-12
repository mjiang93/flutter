import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/remote/api/message_api_service.dart';
import '../datasources/local/dao/message_isar_dao.dart';

/// Message repository implementation
/// 
/// Implements MessageRepository interface with remote API and local cache
class MessageRepositoryImpl implements MessageRepository {
  final MessageApiService _apiService;
  final MessageIsarDao _localDao;

  MessageRepositoryImpl(this._apiService, this._localDao);

  @override
  Future<Either<BaseException, List<MessageEntity>>> getMessageList({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await _apiService.getMessageList(page, pageSize);
      final messages = response.data!.map((m) => m.toEntity()).toList();

      // Cache to local (clear cache on first page)
      if (page == 1) {
        await _localDao.clearAll();
      }
      await _localDao.saveMessages(messages);

      return Right(messages);
    } on DioException catch (e) {
      // Return cached data on network error
      if (e.error is NoInternetConnectionException) {
        final cached = await _localDao.getMessages(
          limit: pageSize,
          offset: (page - 1) * pageSize,
        );
        if (cached.isNotEmpty) {
          return Right(cached);
        }
      }

      if (e.error is BaseException) {
        return Left(e.error as BaseException);
      }
      return Left(
        SystemException('Failed to get messages', originalError: e),
      );
    } catch (e) {
      return Left(
        SystemException('Failed to get messages', originalError: e),
      );
    }
  }

  @override
  Future<Either<BaseException, int>> getUnreadCount() async {
    try {
      final response = await _apiService.getUnreadCount();
      return Right(response.data!);
    } on DioException catch (e) {
      // Return cached count on network error
      if (e.error is NoInternetConnectionException) {
        final count = await _localDao.getUnreadCount();
        return Right(count);
      }

      if (e.error is BaseException) {
        return Left(e.error as BaseException);
      }
      return Left(
        SystemException('Failed to get unread count', originalError: e),
      );
    } catch (e) {
      return Left(
        SystemException('Failed to get unread count', originalError: e),
      );
    }
  }

  @override
  Future<Either<BaseException, void>> markAsRead(String messageId) async {
    try {
      await _apiService.markAsRead(messageId);

      // Update local cache
      await _localDao.markAsRead(messageId);

      return const Right(null);
    } on DioException catch (e) {
      if (e.error is BaseException) {
        return Left(e.error as BaseException);
      }
      return Left(
        SystemException('Failed to mark as read', originalError: e),
      );
    } catch (e) {
      return Left(
        SystemException('Failed to mark as read', originalError: e),
      );
    }
  }

  @override
  Future<Either<BaseException, MessageEntity>> getMessageDetail(
    String messageId,
  ) async {
    try {
      final response = await _apiService.getMessageDetail(messageId);
      return Right(response.data!.toEntity());
    } on DioException catch (e) {
      // Try to get from cache on network error
      if (e.error is NoInternetConnectionException) {
        final cached = await _localDao.getMessageById(messageId);
        if (cached != null) {
          return Right(cached);
        }
      }

      if (e.error is BaseException) {
        return Left(e.error as BaseException);
      }
      return Left(
        SystemException('Failed to get message detail', originalError: e),
      );
    } catch (e) {
      return Left(
        SystemException('Failed to get message detail', originalError: e),
      );
    }
  }

  @override
  Future<List<MessageEntity>> getCachedMessages() async {
    return await _localDao.getMessages();
  }

  @override
  Future<void> cacheMessages(List<MessageEntity> messages) async {
    await _localDao.saveMessages(messages);
  }
}
