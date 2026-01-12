import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/cache_keys.dart';

/// SharedPreferences manager
/// 
/// Manages lightweight key-value storage for app configurations
class SPManager {
  static SharedPreferences? _instance;

  /// Get SharedPreferences instance
  static Future<SharedPreferences> get instance async {
    _instance ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Token management
  static Future<void> saveToken(String token) async {
    final sp = await instance;
    await sp.setString(CacheKeys.token, token);
  }

  static Future<String?> getToken() async {
    final sp = await instance;
    return sp.getString(CacheKeys.token);
  }

  static Future<void> removeToken() async {
    final sp = await instance;
    await sp.remove(CacheKeys.token);
  }

  // User info management
  static Future<void> saveUserInfo(String userInfo) async {
    final sp = await instance;
    await sp.setString(CacheKeys.userInfo, userInfo);
  }

  static Future<String?> getUserInfo() async {
    final sp = await instance;
    return sp.getString(CacheKeys.userInfo);
  }

  static Future<void> removeUserInfo() async {
    final sp = await instance;
    await sp.remove(CacheKeys.userInfo);
  }

  // Theme management
  static Future<void> saveThemeMode(String mode) async {
    final sp = await instance;
    await sp.setString(CacheKeys.themeMode, mode);
  }

  static Future<String?> getThemeMode() async {
    final sp = await instance;
    return sp.getString(CacheKeys.themeMode);
  }

  // Language management
  static Future<void> saveLanguage(String languageCode) async {
    final sp = await instance;
    await sp.setString(CacheKeys.language, languageCode);
  }

  static Future<String?> getLanguage() async {
    final sp = await instance;
    return sp.getString(CacheKeys.language);
  }

  // First launch flag
  static Future<void> setFirstLaunch(bool isFirst) async {
    final sp = await instance;
    await sp.setBool(CacheKeys.isFirstLaunch, isFirst);
  }

  static Future<bool> isFirstLaunch() async {
    final sp = await instance;
    return sp.getBool(CacheKeys.isFirstLaunch) ?? true;
  }

  // Clear all data
  static Future<void> clearAll() async {
    final sp = await instance;
    await sp.clear();
  }
}
