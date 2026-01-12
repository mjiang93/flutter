import 'base_exception.dart';

/// Business logic exceptions
/// 
/// Thrown when business rules are violated or business operations fail.
/// These exceptions typically come from the server with specific error codes.
class BusinessException extends BaseException {
  const BusinessException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// Create a business exception from server response
  factory BusinessException.fromResponse({
    required int code,
    required String message,
    dynamic originalError,
  }) {
    return BusinessException(
      message,
      code: code,
      originalError: originalError,
    );
  }

  /// Check if this is an unauthorized error (401)
  bool get isUnauthorized => code == 401;

  /// Check if this is a forbidden error (403)
  bool get isForbidden => code == 403;

  /// Check if this is a not found error (404)
  bool get isNotFound => code == 404;

  /// Check if this is a server error (5xx)
  bool get isServerError => code != null && code! >= 500 && code! < 600;
}

/// Exception thrown when user is not authorized
class UnauthorizedException extends BusinessException {
  const UnauthorizedException({String? message})
      : super(
          message ?? 'Unauthorized',
          code: 401,
        );
}

/// Exception thrown when user doesn't have permission
class ForbiddenException extends BusinessException {
  const ForbiddenException({String? message})
      : super(
          message ?? 'Forbidden',
          code: 403,
        );
}

/// Exception thrown when resource is not found
class NotFoundException extends BusinessException {
  const NotFoundException({String? message})
      : super(
          message ?? 'Not found',
          code: 404,
        );
}

/// Exception thrown when validation fails
class ValidationException extends BusinessException {
  const ValidationException({String? message})
      : super(
          message ?? 'Validation failed',
          code: 400,
        );
}
