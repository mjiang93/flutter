import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/log_util.dart';

/// Error interceptor
/// 
/// Converts Dio errors to custom exceptions
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    BaseException exception;

    // If error is already a BaseException, use it
    if (err.error is BaseException) {
      exception = err.error as BaseException;
    } else {
      // Convert DioException to BaseException
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
          exception = ConnectionTimeoutException();
          break;

        case DioExceptionType.sendTimeout:
          exception = SendTimeoutException();
          break;

        case DioExceptionType.receiveTimeout:
          exception = ReceiveTimeoutException();
          break;

        case DioExceptionType.badResponse:
          final statusCode = err.response?.statusCode;
          final message = err.response?.data?['message'] ?? 'Bad response';
          exception = NetworkException(message, code: statusCode);
          break;

        case DioExceptionType.cancel:
          exception = RequestCancelledException();
          break;

        case DioExceptionType.connectionError:
          exception = NoInternetConnectionException();
          break;

        case DioExceptionType.badCertificate:
          exception = NetworkException('SSL certificate error', code: -5);
          break;

        case DioExceptionType.unknown:
        default:
          exception = SystemException(
            err.message ?? 'Unknown error',
            originalError: err,
          );
      }
    }

    LogUtil.e('Network error: ${exception.message}', exception);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        error: exception,
        type: err.type,
      ),
    );
  }
}
