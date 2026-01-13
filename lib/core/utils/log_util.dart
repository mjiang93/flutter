// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../configs/flavor_config.dart';

/// Logging utility with environment-aware logging
/// 
/// Provides structured logging with different levels:
/// - Debug: Detailed information for debugging
/// - Info: General information
/// - Warning: Warning messages
/// - Error: Error messages with stack traces
/// 
/// In development: All logs are printed
/// In production: Only error logs are printed (with sensitive data masked)
class LogUtil {
  LogUtil._();

  static Logger? _logger;

  /// Get logger instance
  static Logger get _instance {
    _logger ??= Logger(
      filter: _LogFilter(),
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      output: _LogOutput(),
    );
    return _logger!;
  }

  /// Log debug message
  /// 
  /// Only printed in development environment.
  /// 
  /// Example:
  /// ```dart
  /// LogUtil.d('User logged in', userId);
  /// ```
  static void d(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (FlavorConfig.instance.enableDebugLog) {
      _instance.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log info message
  /// 
  /// Printed in all environments.
  /// 
  /// Example:
  /// ```dart
  /// LogUtil.i('App started');
  /// ```
  static void i(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _instance.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  /// 
  /// Printed in all environments.
  /// 
  /// Example:
  /// ```dart
  /// LogUtil.w('Cache miss for key: $key');
  /// ```
  static void w(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _instance.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  /// 
  /// Printed in all environments and reported to Crashlytics in production.
  /// 
  /// Example:
  /// ```dart
  /// LogUtil.e('Failed to fetch data', error, stackTrace);
  /// ```
  static void e(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _instance.e(message, error: error, stackTrace: stackTrace);

    // Firebase temporarily disabled
    // // Report to Crashlytics
    // if (error != null) {
    //   try {
    //     FirebaseCrashlytics.instance.recordError(
    //       error,
    //       stackTrace,
    //       reason: message,
    //       fatal: false,
    //     );
    //   } catch (e) {
    //     // Ignore Crashlytics errors to prevent infinite loop
    //     debugPrint('Failed to report error to Crashlytics: $e');
    //   }
    // }
  }

  /// Log verbose message (very detailed)
  /// 
  /// Only printed in development environment.
  /// 
  /// Example:
  /// ```dart
  /// LogUtil.v('Request headers: $headers');
  /// ```
  static void v(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (FlavorConfig.instance.enableDebugLog) {
      _instance.t(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log network request
  /// 
  /// Logs HTTP request details in development.
  /// 
  /// Example:
  /// ```dart
  /// LogUtil.request('GET', '/api/users', headers, body);
  /// ```
  static void request(
    String method,
    String url, [
    Map<String, dynamic>? headers,
    dynamic body,
  ]) {
    if (!FlavorConfig.instance.enableDebugLog) return;

    final buffer = StringBuffer()
      ..writeln('┌─────────────────────────────────────────────')
      ..writeln('│ HTTP REQUEST')
      ..writeln('├─────────────────────────────────────────────')
      ..writeln('│ Method: $method')
      ..writeln('│ URL: $url');

    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('│ Headers:');
      headers.forEach((key, value) {
        // Mask sensitive headers
        final maskedValue = _maskSensitiveData(key, value.toString());
        buffer.writeln('│   $key: $maskedValue');
      });
    }

    if (body != null) {
      buffer
        ..writeln('│ Body:')
        ..writeln('│   $body');
    }

    buffer.writeln('└─────────────────────────────────────────────');

    d(buffer.toString());
  }

  /// Log network response
  /// 
  /// Logs HTTP response details in development.
  /// 
  /// Example:
  /// ```dart
  /// LogUtil.response(200, '/api/users', responseData);
  /// ```
  static void response(
    int statusCode,
    String url, [
    dynamic data,
  ]) {
    if (!FlavorConfig.instance.enableDebugLog) return;

    final buffer = StringBuffer()
      ..writeln('┌─────────────────────────────────────────────')
      ..writeln('│ HTTP RESPONSE')
      ..writeln('├─────────────────────────────────────────────')
      ..writeln('│ Status: $statusCode')
      ..writeln('│ URL: $url');

    if (data != null) {
      buffer
        ..writeln('│ Data:')
        ..writeln('│   $data');
    }

    buffer.writeln('└─────────────────────────────────────────────');

    d(buffer.toString());
  }

  /// Mask sensitive data in logs
  static String _maskSensitiveData(String key, String value) {
    final lowerKey = key.toLowerCase();

    // Mask tokens, passwords, keys
    if (lowerKey.contains('token') ||
        lowerKey.contains('password') ||
        lowerKey.contains('key') ||
        lowerKey.contains('secret')) {
      if (value.length <= 4) return '****';
      return '${value.substring(0, 4)}****';
    }

    return value;
  }
}

/// Custom log filter based on environment
class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // In production, only log errors
    if (FlavorConfig.instance.isProd) {
      return event.level.index >= Level.error.index;
    }

    // In development, log everything
    return true;
  }
}

/// Custom log output
class _LogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      // Use debugPrint to avoid truncation in Flutter
      debugPrint(line);
    }
  }
}
