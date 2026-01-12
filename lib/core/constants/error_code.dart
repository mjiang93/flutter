/// Error code constants for system and business errors
class ErrorCode {
  ErrorCode._();

  // System errors (-1 to -999)
  static const int noInternet = -1;
  static const int connectionTimeout = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cancel = -5;
  static const int unknown = -999;

  // HTTP errors (400-599)
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int requestTimeout = 408;
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;

  // Business errors (1000+)
  static const int success = 200;
  static const int invalidParameter = 1001;
  static const int dataNotFound = 1002;
  static const int dataAlreadyExists = 1003;
  static const int operationFailed = 1004;
  static const int permissionDenied = 1005;
  static const int tokenExpired = 1006;
  static const int tokenInvalid = 1007;
  static const int userNotFound = 1008;
  static const int userDisabled = 1009;
  static const int passwordIncorrect = 1010;

  /// Get error message by code
  static String getMessage(int code) {
    switch (code) {
      case noInternet:
        return 'No internet connection';
      case connectionTimeout:
        return 'Connection timeout';
      case receiveTimeout:
        return 'Receive timeout';
      case sendTimeout:
        return 'Send timeout';
      case cancel:
        return 'Request cancelled';
      case badRequest:
        return 'Bad request';
      case unauthorized:
        return 'Unauthorized';
      case forbidden:
        return 'Forbidden';
      case notFound:
        return 'Not found';
      case internalServerError:
        return 'Internal server error';
      case badGateway:
        return 'Bad gateway';
      case serviceUnavailable:
        return 'Service unavailable';
      case gatewayTimeout:
        return 'Gateway timeout';
      case invalidParameter:
        return 'Invalid parameter';
      case dataNotFound:
        return 'Data not found';
      case dataAlreadyExists:
        return 'Data already exists';
      case operationFailed:
        return 'Operation failed';
      case permissionDenied:
        return 'Permission denied';
      case tokenExpired:
        return 'Token expired';
      case tokenInvalid:
        return 'Token invalid';
      case userNotFound:
        return 'User not found';
      case userDisabled:
        return 'User disabled';
      case passwordIncorrect:
        return 'Password incorrect';
      default:
        return 'Unknown error';
    }
  }
}
