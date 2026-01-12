import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../entities/message_entity.dart';

/// Message repository interface
/// 
/// Defines the contract for message-related data operations
/// Implementations should handle both remote API calls and local caching
abstract class MessageRepository {
  /// Get message list with pagination
  /// 
  /// Returns Either<BaseException, List<MessageEntity>>
  /// - Left: Exception if operation fails
  /// - Right: List of MessageEntity if operation succeeds
  Future<Either<BaseException, List<MessageEntity>>> getMessageList({
    required int page,
    required int pageSize,
  });

  /// Get unread message count
  /// 
  /// Returns Either<BaseException, int>
  /// - Left: Exception if operation fails
  /// - Right: Unread count if operation succeeds
  Future<Either<BaseException, int>> getUnreadCount();

  /// Mark message as read
  /// 
  /// Returns Either<BaseException, void>
  /// - Left: Exception if operation fails
  /// - Right: void if operation succeeds
  Future<Either<BaseException, void>> markAsRead(String messageId);

  /// Get message detail
  /// 
  /// Returns Either<BaseException, MessageEntity>
  /// - Left: Exception if operation fails
  /// - Right: MessageEntity if operation succeeds
  Future<Either<BaseException, MessageEntity>> getMessageDetail(String messageId);

  /// Get cached messages from local storage
  Future<List<MessageEntity>> getCachedMessages();

  /// Cache messages to local storage
  Future<void> cacheMessages(List<MessageEntity> messages);
}
