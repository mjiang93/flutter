import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/route_names.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_user_info_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'base_controller.dart';

/// Mine page controller
/// 
/// Manages mine page state including:
/// - User information display
/// - Logout functionality with confirmation
/// - Navigation to settings pages (theme, language)
class MineController extends BaseController {
  final GetUserInfoUseCase _getUserInfoUseCase;
  final LogoutUseCase _logoutUseCase;

  MineController(
    this._getUserInfoUseCase,
    this._logoutUseCase,
  );

  // Observable variables
  final Rx<UserEntity?> _user = Rx<UserEntity?>(null);

  // Getters
  UserEntity? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  /// Load user information
  /// 
  /// Fetches user data from repository (cache-first strategy)
  Future<void> loadUserInfo() async {
    setLoading();

    // Get user ID from storage or use a default
    // In a real app, this would come from authentication state
    const userId = 'current_user_id';

    final result = await _getUserInfoUseCase(userId);

    handleResult(
      result,
      onSuccess: (userData) {
        _user.value = userData;
        setSuccess();
      },
      onError: (error) {
        // Error state is already set by handleResult
      },
    );
  }

  /// Logout with confirmation dialog
  /// 
  /// Shows confirmation dialog before logging out
  /// Clears all local data and navigates to login page
  Future<void> logout() async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    // If user cancelled, return
    if (confirmed != true) return;

    // Show loading
    setLoading();

    // Call logout use case
    final result = await _logoutUseCase();

    handleResult(
      result,
      onSuccess: (_) {
        // Clear user data
        _user.value = null;
        
        // Navigate to login page and clear navigation stack
        Get.offAllNamed(RouteNames.login);
      },
      onError: (error) {
        // Even if remote logout fails, we still clear local data
        // and navigate to login (this is handled in LogoutUseCase)
        _user.value = null;
        Get.offAllNamed(RouteNames.login);
      },
    );
  }

  /// Navigate to theme setting page
  void navigateToThemeSetting() {
    Get.toNamed(RouteNames.themeSetting);
  }

  /// Navigate to language setting page
  void navigateToLanguageSetting() {
    Get.toNamed(RouteNames.languageSetting);
  }

  /// Navigate to general settings page
  void navigateToSettings() {
    Get.toNamed(RouteNames.setting);
  }
}
