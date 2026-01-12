import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/local/sp_manager.dart';
import 'app_theme.dart';

/// Theme mode enumeration
enum AppThemeMode {
  light,
  dark,
  system,
  custom,
}

/// Theme controller
/// 
/// Manages app theme mode and custom colors
class ThemeController extends GetxController {
  final _themeMode = AppThemeMode.system.obs;
  final Rx<Color?> _customPrimaryColor = Rx<Color?>(null);

  AppThemeMode get themeMode => _themeMode.value;
  Color? get customPrimaryColor => _customPrimaryColor.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  /// Load theme mode from storage
  Future<void> _loadThemeMode() async {
    final savedMode = await SPManager.getThemeMode();
    if (savedMode != null) {
      _themeMode.value = AppThemeMode.values.firstWhere(
        (mode) => mode.name == savedMode,
        orElse: () => AppThemeMode.system,
      );
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode.value = mode;
    await SPManager.saveThemeMode(mode.name);

    // Update GetX theme
    switch (mode) {
      case AppThemeMode.light:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case AppThemeMode.dark:
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case AppThemeMode.system:
        Get.changeThemeMode(ThemeMode.system);
        break;
      case AppThemeMode.custom:
        // Custom theme uses light mode by default
        Get.changeThemeMode(ThemeMode.light);
        break;
    }
  }

  /// Set custom primary color
  Future<void> setCustomPrimaryColor(Color color) async {
    _customPrimaryColor.value = color;
    _themeMode.value = AppThemeMode.custom;
    await SPManager.saveThemeMode(AppThemeMode.custom.name);

    // Update theme with custom color
    Get.changeTheme(AppTheme.customTheme(primaryColor: color));
  }

  /// Get current theme data
  ThemeData getThemeData() {
    if (_themeMode.value == AppThemeMode.custom && _customPrimaryColor.value != null) {
      return AppTheme.customTheme(primaryColor: _customPrimaryColor.value!);
    }

    switch (_themeMode.value) {
      case AppThemeMode.light:
        return AppTheme.lightTheme;
      case AppThemeMode.dark:
        return AppTheme.darkTheme;
      case AppThemeMode.system:
      case AppThemeMode.custom:
        // System mode will be handled by GetMaterialApp
        return AppTheme.lightTheme;
    }
  }

  /// Get dark theme data
  ThemeData getDarkThemeData() {
    if (_themeMode.value == AppThemeMode.custom && _customPrimaryColor.value != null) {
      return AppTheme.customTheme(
        primaryColor: _customPrimaryColor.value!,
        isDark: true,
      );
    }
    return AppTheme.darkTheme;
  }
}
