import 'package:dio/dio.dart';
import '../../../models/base_response.dart';
import '../../../models/user_response.dart';
import 'user_api_service_impl.dart';

/// User API service
/// 
/// Defines user-related API endpoints
abstract class UserApiService {
  factory UserApiService(Dio dio, {String? baseUrl}) => UserApiServiceImpl(dio, baseUrl: baseUrl);

  /// Get user information
  Future<BaseResponse<UserResponse>> getUserInfo(String userId);

  /// Update user information
  Future<BaseResponse<UserResponse>> updateUserInfo(
    String userId,
    Map<String, dynamic> data,
  );

  /// Logout
  Future<BaseResponse<void>> logout();
}

