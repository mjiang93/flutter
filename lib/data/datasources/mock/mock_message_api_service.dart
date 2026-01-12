import 'package:dio/dio.dart';
import '../../models/base_response.dart';
import '../../models/message_response.dart';
import '../remote/api/message_api_service.dart';

/// Mock implementation of MessageApiService for development/testing
/// 
/// Returns predefined mock message data without making actual API calls
class MockMessageApiService implements MessageApiService {
  /// Simulated network delay in milliseconds
  final int delayMs;

  MockMessageApiService({this.delayMs = 800});

  /// Generate mock messages
  List<MessageResponse> _generateMockMessages(int page, int pageSize) {
    final messages = <MessageResponse>[];
    final startIndex = (page - 1) * pageSize;
    
    for (int i = startIndex; i < startIndex + pageSize && i < 50; i++) {
      final messageTypes = ['system', 'notification', 'promotion'];
      final type = messageTypes[i % messageTypes.length];
      
      messages.add(
        MessageResponse(
          id: 'msg_$i',
          title: _getTitleByType(type, i),
          content: _getContentByType(type, i),
          type: type,
          isRead: i % 3 != 0, // Some messages are unread
          createdAt: DateTime.now()
              .subtract(Duration(hours: i))
              .toIso8601String(),
        ),
      );
    }
    
    return messages;
  }

  String _getTitleByType(String type, int index) {
    switch (type) {
      case 'system':
        return 'System Notification #${index + 1}';
      case 'notification':
        return 'New Message #${index + 1}';
      case 'promotion':
        return 'Special Offer #${index + 1}';
      default:
        return 'Message #${index + 1}';
    }
  }

  String _getContentByType(String type, int index) {
    switch (type) {
      case 'system':
        return 'System maintenance scheduled for tonight. Please save your work.';
      case 'notification':
        return 'You have a new notification. Click to view details.';
      case 'promotion':
        return 'Limited time offer! Get 50% off on selected items. Use code: SAVE50';
      default:
        return 'This is a mock message for testing purposes.';
    }
  }

  @override
  Future<BaseResponse<List<MessageResponse>>> getMessageList(
    int page,
    int pageSize,
  ) async {
    await Future.delayed(Duration(milliseconds: delayMs));
    
    return BaseResponse(
      code: 200,
      message: 'Success',
      data: _generateMockMessages(page, pageSize),
    );
  }

  @override
  Future<BaseResponse<int>> getUnreadCount() async {
    await Future.delayed(Duration(milliseconds: delayMs));
    
    return const BaseResponse(
      code: 200,
      message: 'Success',
      data: 5,
    );
  }

  @override
  Future<BaseResponse<void>> markAsRead(String messageId) async {
    await Future.delayed(Duration(milliseconds: delayMs));
    
    return const BaseResponse(
      code: 200,
      message: 'Message marked as read',
    );
  }

  @override
  Future<BaseResponse<MessageResponse>> getMessageDetail(String messageId) async {
    await Future.delayed(Duration(milliseconds: delayMs));
    
    return BaseResponse(
      code: 200,
      message: 'Success',
      data: MessageResponse(
        id: messageId,
        title: 'Message Detail',
        content: 'This is a detailed view of the message. '
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        type: 'notification',
        isRead: true,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
  }
}
