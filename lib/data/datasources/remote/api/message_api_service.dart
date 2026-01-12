import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../models/base_response.dart';
import '../../../models/message_response.dart';

part 'message_api_service.g.dart';

/// Message API service
/// 
/// Defines message-related API endpoints using Retrofit
@RestApi()
abstract class MessageApiService {
  factory MessageApiService(Dio dio, {String? baseUrl}) = _MessageApiService;

  /// Get message list with pagination
  @GET('/messages')
  Future<BaseResponse<List<MessageResponse>>> getMessageList(
    @Query('page') int page,
    @Query('page_size') int pageSize,
  );

  /// Get unread message count
  @GET('/messages/unread-count')
  Future<BaseResponse<int>> getUnreadCount();

  /// Mark message as read
  @PUT('/messages/{id}/read')
  Future<BaseResponse<void>> markAsRead(@Path('id') String messageId);

  /// Get message detail
  @GET('/messages/{id}')
  Future<BaseResponse<MessageResponse>> getMessageDetail(
    @Path('id') String messageId,
  );
}
