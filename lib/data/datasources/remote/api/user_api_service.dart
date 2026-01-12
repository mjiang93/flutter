import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../models/base_response.dart';
import '../../../models/user_response.dart';

part 'user_api_service.g.dart';

/// User API service
/// 
/// Defines user-related API endpoints using Retrofit
@RestApi()
abstract class UserApiService {
  factory UserApiService(Dio dio, {String? baseUrl}) = _UserApiService;

  /// Get user information
  @GET('/user/{id}')
  Future<BaseResponse<UserResponse>> getUserInfo(@Path('id') String userId);

  /// Update user information
  @PUT('/user/{id}')
  Future<BaseResponse<UserResponse>> updateUserInfo(
    @Path('id') String userId,
    @Body() Map<String, dynamic> data,
  );

  /// Logout
  @DELETE('/auth/logout')
  Future<BaseResponse<void>> logout();
}
