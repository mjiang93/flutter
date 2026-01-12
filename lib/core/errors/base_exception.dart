/// Base exception class for all custom exceptions
/// 
/// All custom exceptions in the app should extend this class
/// to provide consistent error handling and reporting.
abstract class BaseException implements Exception {
  /// Human-readable error message
  final String message;

  /// Optional error code for categorization
  final int? code;

  /// Original error that caused this exception (if any)
  final dynamic originalError;

  /// Stack trace of the original error (if any)
  final StackTrace? stackTrace;

  const BaseException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write(runtimeType)
      ..write(': ')
      ..write(message);

    if (code != null) {
      buffer
        ..write(' (code: ')
        ..write(code)
        ..write(')');
    }

    if (originalError != null) {
      buffer
        ..write('\nOriginal error: ')
        ..write(originalError);
    }

    return buffer.toString();
  }
}
