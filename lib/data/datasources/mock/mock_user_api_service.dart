import 'package:dio/dio.dart';
import '../../models/base_response.dart';
import '../../models/user_response.dart';
import '../remote/api/user_api_service.dart';

/// Mock implementation of UserApiService for development/testing
/// 
/// Returns predefined mock data without making actual API calls
class MockUserApiService implements UserApiService {
  /// Simulated network delay in milliseconds
  final int delayMs;

  MockUserApiService({this.delayMs = 800});

  @override
  Future<BaseResponse<UserResponse>> getUserInfo(String userId) async {
    await Future.delayed(Duration(milliseconds: delayMs));
    
    return BaseResponse(
      code: 200,
      message: 'Success',
      data: UserResponse(
        id: userId,
        nickname: 'John Doe',
        phone: '13800138000',
        avatar: 'https://via.placeholder.com/150',
        email: 'john.doe@example.com',
        isVip: true,
        createdAt: DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
      ),
    );
  }

  @override
  Future<BaseResponse<UserResponse>> updateUserInfo(
    String userId,
    Map<String, dynamic> data,
  ) async {
    await Future.delayed(Duration(milliseconds: delayMs));
    
    return BaseResponse(
      code: 200,
      message: 'User info updated successfully',
      data: UserResponse(
        id: userId,
        nickname: data['nickname'] ?? 'John Doe',
        phone: '13800138000',
        avatar: data['avatar'] ?? 'https://via.placeholder.com/150',
        email: data['email'] ?? 'john.doe@example.com',
        isVip: true,
        createdAt: DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
      ),
    );
  }

  @override
  Future<BaseResponse<void>> logout() async {
    await Future.delayed(Duration(milliseconds: delayMs));
    
    return const BaseResponse(
      code: 200,
      message: 'Logout successful',
    );
  }
}
