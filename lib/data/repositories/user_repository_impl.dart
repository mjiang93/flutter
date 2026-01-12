import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/api/user_api_service.dart';
import '../datasources/local/dao/user_isar_dao.dart';
import '../datasources/local/sp_manager.dart';

/// User repository implementation
/// 
/// Implements UserRepository interface with remote API and local cache
class UserRepositoryImpl implements UserRepository {
  final UserApiService _apiService;
  final UserIsarDao _localDao;

  UserRepositoryImpl(this._apiService, this._localDao);

  @override
  Future<Either<BaseException, UserEntity>> getUserInfo(String userId) async {
    try {
      final response = await _apiService.getUserInfo(userId);
      final user = response.data!.toEntity();

      // Cache to local
      await _localDao.saveUserInfo(user);

      return Right(user);
    } on DioException catch (e) {
      if (e.error is BaseException) {
        return Left(e.error as BaseException);
      }
      return Left(
        SystemException('Failed to get user info', originalError: e),
      );
    } catch (e, stackTrace) {
      return Left(
        SystemException(
          'Failed to get user info',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<BaseException, UserEntity>> updateUserInfo(
    UserEntity user,
  ) async {
    try {
      final response = await _apiService.updateUserInfo(
        user.id,
        {
          'nickname': user.nickname,
          'avatar': user.avatar,
          'email': user.email,
        },
      );
      final updatedUser = response.data!.toEntity();

      // Update local cache
      await _localDao.saveUserInfo(updatedUser);

      return Right(updatedUser);
    } on DioException catch (e) {
      if (e.error is BaseException) {
        return Left(e.error as BaseException);
      }
      return Left(
        SystemException('Failed to update user info', originalError: e),
      );
    } catch (e) {
      return Left(
        SystemException('Failed to update user info', originalError: e),
      );
    }
  }

  @override
  Future<Either<BaseException, void>> logout() async {
    try {
      await _apiService.logout();
      return const Right(null);
    } on DioException catch (e) {
      if (e.error is BaseException) {
        return Left(e.error as BaseException);
      }
      return Left(SystemException('Failed to logout', originalError: e));
    } catch (e) {
      return Left(SystemException('Failed to logout', originalError: e));
    }
  }

  @override
  Future<UserEntity?> getCachedUserInfo() async {
    try {
      final token = await SPManager.getToken();
      if (token == null) return null;

      // In a real app, you would decode the token to get the user ID
      // For now, we'll get the first user from the cache
      // This is a simplified implementation
      final userInfo = await SPManager.getUserInfo();
      if (userInfo == null) return null;

      // Parse and return user entity
      // In production, you'd decode JSON here
      return null; // Placeholder
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUserInfo(UserEntity user) async {
    await _localDao.saveUserInfo(user);
  }

  @override
  Future<void> clearCachedUserInfo() async {
    await _localDao.clearAll();
    await SPManager.removeToken();
    await SPManager.removeUserInfo();
  }
}
