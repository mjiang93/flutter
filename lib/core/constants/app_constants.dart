/// Application-wide constants
class AppConstants {
  AppConstants._();

  // Storage keys
  static const String keyToken = 'token';
  static const String keyUserId = 'user_id';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyLastSyncTime = 'last_sync_time';

  // Default values
  static const String defaultLanguage = 'en';
  static const String defaultThemeMode = 'system';

  // Limits
  static const int maxUploadFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxImageCacheSize = 100 * 1024 * 1024; // 100MB
  static const int maxListCacheCount = 1000;

  // Timeouts
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration toastDuration = Duration(seconds: 2);
  static const Duration dialogDuration = Duration(milliseconds: 300);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
}
