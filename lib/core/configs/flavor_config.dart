/// Flavor configuration for multi-environment support
/// 
/// Supports three environments: dev, staging, prod
/// Each environment has its own API base URL, timeout settings, and encryption key
enum Flavor {
  dev,
  staging,
  prod,
}

/// FlavorConfig holds environment-specific configuration
/// 
/// Usage:
/// ```dart
/// FlavorConfig(
///   flavor: Flavor.dev,
///   apiBaseUrl: 'https://dev-api.example.com',
///   enableDebugLog: true,
///   encryptionKey: 'dev-encryption-key-32-chars',
/// );
/// ```
class FlavorConfig {
  final Flavor flavor;
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableDebugLog;
  final String encryptionKey;

  static FlavorConfig? _instance;

  /// Get the current flavor configuration instance
  static FlavorConfig get instance {
    if (_instance == null) {
      throw StateError(
        'FlavorConfig has not been initialized. '
        'Call FlavorConfig.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Initialize flavor configuration
  /// 
  /// This should be called once at app startup before any other code runs
  factory FlavorConfig({
    required Flavor flavor,
    required String apiBaseUrl,
    Duration connectTimeout = const Duration(seconds: 3),
    Duration receiveTimeout = const Duration(seconds: 10),
    bool enableDebugLog = false,
    required String encryptionKey,
  }) {
    _instance = FlavorConfig._internal(
      flavor: flavor,
      apiBaseUrl: apiBaseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      enableDebugLog: enableDebugLog,
      encryptionKey: encryptionKey,
    );
    return _instance!;
  }

  FlavorConfig._internal({
    required this.flavor,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.enableDebugLog,
    required this.encryptionKey,
  });

  /// Check if current flavor is development
  bool get isDev => flavor == Flavor.dev;

  /// Check if current flavor is staging
  bool get isStaging => flavor == Flavor.staging;

  /// Check if current flavor is production
  bool get isProd => flavor == Flavor.prod;

  @override
  String toString() {
    return 'FlavorConfig('
        'flavor: ${flavor.name}, '
        'apiBaseUrl: $apiBaseUrl, '
        'enableDebugLog: $enableDebugLog'
        ')';
  }
}
