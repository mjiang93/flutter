import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/message_entity.dart';

part 'message_response.freezed.dart';
part 'message_response.g.dart';

/// Message response model from API
/// 
/// Maps API response to domain entity
@freezed
class MessageResponse with _$MessageResponse {
  const MessageResponse._();

  const factory MessageResponse({
    required String id,
    required String title,
    required String content,
    required String type,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _MessageResponse;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);

  /// Convert to domain entity
  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      title: title,
      content: content,
      type: _parseMessageType(type),
      isRead: isRead,
      createdAt: DateTime.parse(createdAt),
    );
  }

  /// Parse message type from string
  static MessageType _parseMessageType(String type) {
    switch (type.toLowerCase()) {
      case 'system':
        return MessageType.system;
      case 'notification':
        return MessageType.notification;
      case 'promotion':
        return MessageType.promotion;
      default:
        return MessageType.system;
    }
  }
}
