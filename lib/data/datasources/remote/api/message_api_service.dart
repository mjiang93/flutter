import 'package:dio/dio.dart';
import '../../../models/base_response.dart';
import '../../../models/message_response.dart';
import 'message_api_service_impl.dart';

/// Message API service
/// 
/// Defines message-related API endpoints
abstract class MessageApiService {
  factory MessageApiService(Dio dio, {String? baseUrl}) => MessageApiServiceImpl(dio, baseUrl: baseUrl);

  /// Get message list with pagination
  Future<BaseResponse<List<MessageResponse>>> getMessageList(
    int page,
    int pageSize,
  );

  /// Get unread message count
  Future<BaseResponse<int>> getUnreadCount();

  /// Mark message as read
  Future<BaseResponse<void>> markAsRead(String messageId);

  /// Get message detail
  Future<BaseResponse<MessageResponse>> getMessageDetail(String messageId);
}
