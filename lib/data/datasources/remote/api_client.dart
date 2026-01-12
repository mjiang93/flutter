import 'package:dio/dio.dart';
import '../../../core/configs/app_config.dart';
import '../../../core/configs/flavor_config.dart';
import 'interceptors/request_interceptor.dart';
import 'interceptors/response_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// API client configuration
/// 
/// Configures Dio with base URL, timeouts, and interceptors
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.addAll([
      RequestInterceptor(),
      ResponseInterceptor(),
      ErrorInterceptor(),
      if (FlavorConfig.instance.enableDebugLog)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
        ),
    ]);
  }

  Dio get dio => _dio;
}
