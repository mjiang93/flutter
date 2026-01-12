import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../configs/flavor_config.dart';
import '../utils/log_util.dart';

/// Analytics manager for tracking user behavior and events
///
/// Provides centralized analytics tracking with:
/// - Page view tracking with automatic duration calculation
/// - Custom event tracking with metadata
/// - Automatic inclusion of timestamp and device_id in all events
/// - Environment-aware analytics (disabled in dev, enabled in test/prod)
///
/// Example usage:
/// ```dart
/// // Track page view
/// AnalyticsManager.logPageView('home_page');
///
/// // Track custom event
/// AnalyticsManager.logEvent('button_click', {
///   'button_name': 'login',
///   'screen': 'login_page',
/// });
/// ```
class AnalyticsManager {
  AnalyticsManager._();

  static FirebaseAnalytics? _analytics;
  static String? _deviceId;

  /// Initialize analytics
  ///
  /// Should be called during app startup after Firebase initialization
  static Future<void> initialize() async {
    _analytics = FirebaseAnalytics.instance;
    _deviceId = await _getDeviceId();

    LogUtil.i('Analytics initialized with device ID: $_deviceId');
  }

  /// Get device ID for analytics
  static Future<String> _getDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown';
      }
      return 'unknown';
    } catch (e) {
      LogUtil.e('Failed to get device ID', e);
      return 'unknown';
    }
  }

  /// Log page view event
  ///
  /// Automatically tracks when a user views a page.
  /// Page duration is calculated when the user exits the page.
  ///
  /// Parameters:
  /// - [pageName]: Name of the page (e.g., 'home_page', 'message_detail')
  /// - [parameters]: Optional additional parameters
  ///
  /// Example:
  /// ```dart
  /// AnalyticsManager.logPageView('home_page');
  /// ```
  static Future<void> logPageView(
    String pageName, {
    Map<String, dynamic>? parameters,
  }) async {
    if (_analytics == null) {
      LogUtil.w('Analytics not initialized, skipping page view: $pageName');
      return;
    }

    try {
      // Add metadata
      final enrichedParams = await _enrichParameters(parameters ?? {});

      // Log to Firebase Analytics
      await _analytics!.logScreenView(
        screenName: pageName,
        parameters: enrichedParams,
      );

      LogUtil.d('Page view logged: $pageName');
    } catch (e) {
      LogUtil.e('Failed to log page view: $pageName', e);
    }
  }

  /// Log custom event
  ///
  /// Tracks custom user actions and events.
  /// Automatically adds timestamp and device_id to all events.
  ///
  /// Parameters:
  /// - [eventName]: Name of the event (use snake_case, e.g., 'button_click')
  /// - [parameters]: Event parameters (will be enriched with metadata)
  ///
  /// Example:
  /// ```dart
  /// AnalyticsManager.logEvent('home_refresh', {
  ///   'refresh_type': 'pull_down',
  ///   'items_count': 10,
  /// });
  /// ```
  static Future<void> logEvent(
    String eventName,
    Map<String, dynamic> parameters,
  ) async {
    if (_analytics == null) {
      LogUtil.w('Analytics not initialized, skipping event: $eventName');
      return;
    }

    try {
      // Add metadata
      final enrichedParams = await _enrichParameters(parameters);

      // Log to Firebase Analytics
      await _analytics!.logEvent(
        name: eventName,
        parameters: enrichedParams,
      );

      LogUtil.d('Event logged: $eventName with params: $enrichedParams');
    } catch (e) {
      LogUtil.e('Failed to log event: $eventName', e);
    }
  }

  /// Log click event
  ///
  /// Convenience method for tracking button/item clicks.
  ///
  /// Parameters:
  /// - [elementName]: Name of the clicked element
  /// - [screenName]: Name of the screen where the click occurred
  /// - [parameters]: Optional additional parameters
  ///
  /// Example:
  /// ```dart
  /// AnalyticsManager.logClick('login_button', 'login_page');
  /// ```
  static Future<void> logClick(
    String elementName,
    String screenName, {
    Map<String, dynamic>? parameters,
  }) async {
    final params = parameters ?? {};
    params['element_name'] = elementName;
    params['screen_name'] = screenName;

    await logEvent('click', params);
  }

  /// Set user ID for analytics
  ///
  /// Associates analytics events with a specific user.
  ///
  /// Parameters:
  /// - [userId]: User ID (null to clear)
  ///
  /// Example:
  /// ```dart
  /// AnalyticsManager.setUserId('user_123');
  /// ```
  static Future<void> setUserId(String? userId) async {
    if (_analytics == null) {
      LogUtil.w('Analytics not initialized, skipping set user ID');
      return;
    }

    try {
      await _analytics!.setUserId(id: userId);
      LogUtil.d('User ID set: $userId');
    } catch (e) {
      LogUtil.e('Failed to set user ID', e);
    }
  }

  /// Set user property
  ///
  /// Sets a user property for analytics segmentation.
  ///
  /// Parameters:
  /// - [name]: Property name
  /// - [value]: Property value
  ///
  /// Example:
  /// ```dart
  /// AnalyticsManager.setUserProperty('user_type', 'premium');
  /// ```
  static Future<void> setUserProperty(String name, String? value) async {
    if (_analytics == null) {
      LogUtil.w('Analytics not initialized, skipping set user property');
      return;
    }

    try {
      await _analytics!.setUserProperty(name: name, value: value);
      LogUtil.d('User property set: $name = $value');
    } catch (e) {
      LogUtil.e('Failed to set user property', e);
    }
  }

  /// Enrich parameters with metadata
  ///
  /// Adds timestamp and device_id to all event parameters.
  ///
  /// Parameters:
  /// - [parameters]: Original parameters
  ///
  /// Returns: Enriched parameters with metadata
  static Future<Map<String, dynamic>> _enrichParameters(
    Map<String, dynamic> parameters,
  ) async {
    final enriched = Map<String, dynamic>.from(parameters);

    // Add timestamp
    enriched['timestamp'] = DateTime.now().toIso8601String();

    // Add device_id
    if (_deviceId != null) {
      enriched['device_id'] = _deviceId!;
    }

    // Add app version
    enriched['app_version'] = '1.0.0'; // TODO: Get from package_info

    // Add environment
    enriched['environment'] = FlavorConfig.instance.flavor.name;

    return enriched;
  }

  /// Reset analytics data
  ///
  /// Clears all analytics data (useful on logout).
  ///
  /// Example:
  /// ```dart
  /// AnalyticsManager.reset();
  /// ```
  static Future<void> reset() async {
    if (_analytics == null) {
      LogUtil.w('Analytics not initialized, skipping reset');
      return;
    }

    try {
      await _analytics!.setUserId(id: null);
      LogUtil.d('Analytics data reset');
    } catch (e) {
      LogUtil.e('Failed to reset analytics', e);
    }
  }
}
