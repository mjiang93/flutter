import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/configs/app_config.dart';
import '../../../../core/configs/flavor_config.dart';
import '../../../../core/constants/cache_keys.dart';
import '../../../../core/utils/encryption_util.dart';
import '../../../../core/utils/log_util.dart';

/// Request interceptor
/// 
/// Adds common headers and encrypts request body for non-GET requests
class RequestInterceptor extends Interceptor {
  // Track in-flight requests to prevent duplicates
  final Map<String, CancelToken> _inFlightRequests = {};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Request deduplication: check if same request is already in flight
      final requestKey = _generateRequestKey(options);
      if (_inFlightRequests.containsKey(requestKey)) {
        LogUtil.d('Duplicate request detected, using existing: $requestKey');
        // Cancel this duplicate request
        handler.reject(
          DioException(
            requestOptions: options,
            error: const RequestCancelledException(),
            type: DioExceptionType.cancel,
          ),
        );
        return;
      }

      // Track this request
      final cancelToken = CancelToken();
      _inFlightRequests[requestKey] = cancelToken;
      options.cancelToken = cancelToken;

      // Add authentication token
      final token = await _getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      // Add device information
      options.headers['device-id'] = await _getDeviceId();
      options.headers['app-version'] = AppConfig.version;
      options.headers['os-type'] = Platform.isIOS ? 'iOS' : 'Android';
      options.headers['lang'] = await _getLanguage();

      // Encrypt non-GET request parameters if needed
      if (options.method != 'GET' && 
          options.data != null && 
          FlavorConfig.instance.flavor == Flavor.prod) {
        final encrypted = EncryptionUtil.encryptAES(
          jsonEncode(options.data),
          FlavorConfig.instance.encryptionKey,
        );
        options.data = {'encrypted': encrypted};
      }

      LogUtil.d('Request: ${options.method} ${options.uri}');
      handler.next(options);
    } catch (e, stackTrace) {
      LogUtil.e('Request interceptor error', e, stackTrace);
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Remove from in-flight requests
    final requestKey = _generateRequestKey(response.requestOptions);
    _inFlightRequests.remove(requestKey);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Remove from in-flight requests
    final requestKey = _generateRequestKey(err.requestOptions);
    _inFlightRequests.remove(requestKey);
    super.onError(err, handler);
  }

  /// Generate a unique key for a request based on method, path, and query params
  String _generateRequestKey(RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    final queryString = uri.query.isEmpty ? '' : '?${uri.query}';
    return '$method:${uri.path}$queryString';
  }

  Future<String?> _getToken() async {
    try {
      final sp = await SharedPreferences.getInstance();
      return sp.getString(CacheKeys.token);
    } catch (e) {
      LogUtil.e('Failed to get token', e);
      return null;
    }
  }

  Future<String> _getDeviceId() async {
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

  Future<String> _getLanguage() async {
    try {
      final sp = await SharedPreferences.getInstance();
      return sp.getString(CacheKeys.language) ?? 'en';
    } catch (e) {
      LogUtil.e('Failed to get language', e);
      return 'en';
    }
  }
}
