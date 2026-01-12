import 'package:isar/isar.dart';
import '../../../../domain/entities/message_entity.dart';

part 'message_isar_model.g.dart';

/// Message Isar model for local storage
@collection
class MessageIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String messageId;

  late String title;
  late String content;

  @Enumerated(EnumType.name)
  late MessageType type;

  late bool isRead;

  @Index()
  late DateTime createdAt;

  /// Convert to domain entity
  MessageEntity toEntity() {
    return MessageEntity(
      id: messageId,
      title: title,
      content: content,
      type: type,
      isRead: isRead,
      createdAt: createdAt,
    );
  }

  /// Create from domain entity
  static MessageIsarModel fromEntity(MessageEntity entity) {
    return MessageIsarModel()
      ..messageId = entity.id
      ..title = entity.title
      ..content = entity.content
      ..type = entity.type
      ..isRead = entity.isRead
      ..createdAt = entity.createdAt;
  }
}
