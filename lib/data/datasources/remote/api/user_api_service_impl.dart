import 'package:dio/dio.dart';
import '../../../models/base_response.dart';
import '../../../models/user_response.dart';
import 'user_api_service.dart';

/// Manual implementation of UserApiService
/// 
/// This is a temporary implementation until retrofit_generator is fixed
class UserApiServiceImpl implements UserApiService {
  final Dio _dio;
  final String? _baseUrl;

  UserApiServiceImpl(this._dio, {String? baseUrl}) : _baseUrl = baseUrl;

  String get baseUrl => _baseUrl ?? _dio.options.baseUrl;

  @override
  Future<BaseResponse<UserResponse>> getUserInfo(String userId) async {
    final response = await _dio.get('$baseUrl/user/$userId');
    return BaseResponse<UserResponse>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => UserResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<UserResponse>> updateUserInfo(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put(
      '$baseUrl/user/$userId',
      data: data,
    );
    return BaseResponse<UserResponse>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => UserResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<void>> logout() async {
    final response = await _dio.delete('$baseUrl/auth/logout');
    return BaseResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => null,
    );
  }
}
