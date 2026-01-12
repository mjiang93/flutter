import 'base_exception.dart';

/// Network-related exceptions
/// 
/// Thrown when network operations fail due to connectivity issues,
/// timeouts, or server errors.
class NetworkException extends BaseException {
  const NetworkException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// Create a network exception from an error code
  factory NetworkException.fromCode(int code, {dynamic originalError}) {
    String message;
    switch (code) {
      case -1:
        message = 'No internet connection';
        break;
      case -2:
        message = 'Connection timeout';
        break;
      case -3:
        message = 'Receive timeout';
        break;
      case -4:
        message = 'Send timeout';
        break;
      case 404:
        message = 'Resource not found';
        break;
      case 500:
        message = 'Internal server error';
        break;
      case 502:
        message = 'Bad gateway';
        break;
      case 503:
        message = 'Service unavailable';
        break;
      case 504:
        message = 'Gateway timeout';
        break;
      default:
        message = 'Network error';
    }

    return NetworkException(
      message,
      code: code,
      originalError: originalError,
    );
  }
}

/// Exception thrown when there is no internet connection
class NoInternetConnectionException extends NetworkException {
  const NoInternetConnectionException()
      : super(
          'No internet connection',
          code: -1,
        );
}

/// Exception thrown when connection times out
class ConnectionTimeoutException extends NetworkException {
  const ConnectionTimeoutException()
      : super(
          'Connection timeout',
          code: -2,
        );
}

/// Exception thrown when receiving data times out
class ReceiveTimeoutException extends NetworkException {
  const ReceiveTimeoutException()
      : super(
          'Receive timeout',
          code: -3,
        );
}

/// Exception thrown when sending data times out
class SendTimeoutException extends NetworkException {
  const SendTimeoutException()
      : super(
          'Send timeout',
          code: -4,
        );
}

/// Exception thrown when request is cancelled
class RequestCancelledException extends NetworkException {
  const RequestCancelledException()
      : super(
          'Request cancelled',
          code: -5,
        );
}
