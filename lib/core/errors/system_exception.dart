import 'base_exception.dart';

/// System-level exceptions
/// 
/// Thrown when system-level operations fail, such as serialization,
/// file I/O, or unexpected runtime errors.
class SystemException extends BaseException {
  const SystemException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown when JSON serialization/deserialization fails
class JsonSerializableException extends SystemException {
  const JsonSerializableException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  /// Create from a serialization error
  factory JsonSerializableException.fromError(
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    return JsonSerializableException(
      'Failed to serialize/deserialize JSON: ${error.toString()}',
      originalError: error,
      stackTrace: stackTrace,
    );
  }
}

/// Exception thrown when database operations fail
class DatabaseException extends SystemException {
  const DatabaseException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown when file operations fail
class FileSystemException extends SystemException {
  const FileSystemException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown when encryption/decryption fails
class EncryptionException extends SystemException {
  const EncryptionException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown for unexpected null values
class NullValueException extends SystemException {
  const NullValueException(String fieldName)
      : super('Unexpected null value for field: $fieldName');
}

/// Exception thrown for invalid state
class InvalidStateException extends SystemException {
  const InvalidStateException(super.message);
}
