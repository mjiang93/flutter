import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';
part 'message_entity.g.dart';

/// Message type enumeration
enum MessageType {
  system,
  notification,
  promotion,
}

/// Message entity representing a message in the domain layer
/// 
/// This is a pure domain model with no dependencies on external frameworks
@freezed
class MessageEntity with _$MessageEntity {
  const factory MessageEntity({
    required String id,
    required String title,
    required String content,
    required MessageType type,
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _MessageEntity;

  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);
}
