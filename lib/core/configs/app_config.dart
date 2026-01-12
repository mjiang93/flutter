import 'flavor_config.dart';

/// Application configuration constants
/// 
/// Contains app metadata and environment-specific configurations
class AppConfig {
  AppConfig._();

  // App metadata
  static const String appName = 'Enterprise Flutter App';
  static const String packageName = 'com.enterprise.flutter';
  static const String version = '1.0.0';
  static const int buildNumber = 1;

  // API configurations (environment-specific)
  static String get apiBaseUrl => FlavorConfig.instance.apiBaseUrl;
  static Duration get connectTimeout => FlavorConfig.instance.connectTimeout;
  static Duration get receiveTimeout => FlavorConfig.instance.receiveTimeout;
  static bool get enableDebugLog => FlavorConfig.instance.enableDebugLog;
  static String get encryptionKey => FlavorConfig.instance.encryptionKey;

  // Cache configurations
  static const Duration homeCacheDuration = Duration(minutes: 5);
  static const Duration messageCacheDuration = Duration(minutes: 30);
  static const Duration userCacheDuration = Duration(days: 7);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Network retry
  static const int maxRetryCount = 3;
  static const Duration retryDelay1 = Duration(seconds: 1);
  static const Duration retryDelay2 = Duration(seconds: 2);
  static const Duration retryDelay3 = Duration(seconds: 4);

  // List preload threshold (1.5x screen height)
  static const double listPreloadThreshold = 1.5;

  // Animation durations
  static const Duration tabSwitchDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
}
