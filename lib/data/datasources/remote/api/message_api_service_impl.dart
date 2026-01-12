import 'package:dio/dio.dart';
import '../../../models/base_response.dart';
import '../../../models/message_response.dart';
import 'message_api_service.dart';

/// Manual implementation of MessageApiService
/// 
/// This is a temporary implementation until retrofit_generator is fixed
class MessageApiServiceImpl implements MessageApiService {
  final Dio _dio;
  final String? _baseUrl;

  MessageApiServiceImpl(this._dio, {String? baseUrl}) : _baseUrl = baseUrl;

  String get baseUrl => _baseUrl ?? _dio.options.baseUrl;

  @override
  Future<BaseResponse<List<MessageResponse>>> getMessageList(
    int page,
    int pageSize,
  ) async {
    final response = await _dio.get(
      '$baseUrl/messages',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return BaseResponse<List<MessageResponse>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List)
          .map((e) => MessageResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<BaseResponse<int>> getUnreadCount() async {
    final response = await _dio.get('$baseUrl/messages/unread-count');
    return BaseResponse<int>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as int,
    );
  }

  @override
  Future<BaseResponse<void>> markAsRead(String messageId) async {
    final response = await _dio.put('$baseUrl/messages/$messageId/read');
    return BaseResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => null,
    );
  }

  @override
  Future<BaseResponse<MessageResponse>> getMessageDetail(String messageId) async {
    final response = await _dio.get('$baseUrl/messages/$messageId');
    return BaseResponse<MessageResponse>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => MessageResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
