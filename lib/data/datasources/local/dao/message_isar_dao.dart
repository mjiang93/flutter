import 'package:isar/isar.dart';
import '../../../../domain/entities/message_entity.dart';
import '../models/message_isar_model.dart';

/// Message Isar DAO
/// 
/// Handles message data operations in local Isar database
class MessageIsarDao {
  final Isar _isar;

  MessageIsarDao(this._isar);

  /// Get messages with pagination
  Future<List<MessageEntity>> getMessages({
    int limit = 20,
    int offset = 0,
  }) async {
    final models = await _isar.messageIsarModels
        .where()
        .sortByCreatedAtDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  /// Get unread message count
  Future<int> getUnreadCount() async {
    return await _isar.messageIsarModels
        .filter()
        .isReadEqualTo(false)
        .count();
  }

  /// Save messages
  Future<void> saveMessages(List<MessageEntity> messages) async {
    await _isar.writeTxn(() async {
      final models = messages
          .map((m) => MessageIsarModel.fromEntity(m))
          .toList();
      await _isar.messageIsarModels.putAll(models);
    });
  }

  /// Mark message as read
  Future<void> markAsRead(String messageId) async {
    await _isar.writeTxn(() async {
      final message = await _isar.messageIsarModels
          .filter()
          .messageIdEqualTo(messageId)
          .findFirst();
      if (message != null) {
        message.isRead = true;
        await _isar.messageIsarModels.put(message);
      }
    });
  }

  /// Get message by ID
  Future<MessageEntity?> getMessageById(String messageId) async {
    final model = await _isar.messageIsarModels
        .filter()
        .messageIdEqualTo(messageId)
        .findFirst();
    return model?.toEntity();
  }

  /// Clear all messages
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.messageIsarModels.clear();
    });
  }
}
