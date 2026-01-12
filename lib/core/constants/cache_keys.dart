/// Cache key constants for Isar and SharedPreferences
class CacheKeys {
  CacheKeys._();

  // SharedPreferences keys
  static const String token = 'token';
  static const String userId = 'user_id';
  static const String userInfo = 'user_info';
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String lastSyncTime = 'last_sync_time';
  static const String isFirstLaunch = 'is_first_launch';
  static const String deviceId = 'device_id';

  // Isar collection names
  static const String collectionUser = 'UserIsarModel';
  static const String collectionMessage = 'MessageIsarModel';
  static const String collectionHomeItem = 'HomeItemIsarModel';
  static const String collectionBanner = 'BannerIsarModel';
  static const String collectionCachedRequest = 'CachedRequestIsarModel';
  static const String collectionAnalyticsEvent = 'AnalyticsEventIsarModel';

  // Cache prefixes for request caching
  static const String cachePrefixApi = 'api_cache_';
  static const String cachePrefixImage = 'image_cache_';
}
