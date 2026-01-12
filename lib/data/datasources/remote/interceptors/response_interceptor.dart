import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/configs/flavor_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/encryption_util.dart';
import '../../../../core/utils/log_util.dart';

/// Response interceptor
/// 
/// Handles response status codes and decrypts encrypted responses
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      final data = response.data;

      if (data is Map<String, dynamic>) {
        final code = data['code'] as int?;
        final message = data['message'] as String?;

        // Decrypt response if encrypted
        if (data['data'] is String && data['encrypted'] == true) {
          try {
            final decrypted = EncryptionUtil.decryptAES(
              data['data'],
              FlavorConfig.instance.encryptionKey,
            );
            data['data'] = jsonDecode(decrypted);
          } catch (e) {
            LogUtil.e('Failed to decrypt response', e);
          }
        }

        switch (code) {
          case 200:
            // Success
            handler.next(response);
            break;

          case 401:
            // Unauthorized
            LogUtil.w('Unauthorized: ${message ?? 'Token expired or invalid'}');
            handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                error: UnauthorizedException(message: message),
              ),
            );
            break;

          case 403:
            // Forbidden
            LogUtil.w('Forbidden: ${message ?? 'Permission denied'}');
            handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                error: ForbiddenException(message: message),
              ),
            );
            break;

          case 404:
            // Not found
            LogUtil.e('API not found: ${response.requestOptions.uri}');
            handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                error: NotFoundException(message: message),
              ),
            );
            break;

          case 422:
            // Validation error
            handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                error: ValidationException(message: message),
              ),
            );
            break;

          case 500:
          case 502:
          case 503:
          case 504:
            // Server error
            LogUtil.e('Server error: $code - $message');
            handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                error: NetworkException('Server error', code: code),
              ),
            );
            break;

          default:
            // Unknown error
            handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                error: BusinessException(
                  message ?? 'Unknown error',
                  code: code,
                ),
              ),
            );
        }
      } else {
        handler.next(response);
      }
    } catch (e, stackTrace) {
      LogUtil.e('Response interceptor error', e, stackTrace);
      handler.next(response);
    }
  }
}
