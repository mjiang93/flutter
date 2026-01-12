import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

import '../errors/exceptions.dart';

/// Encryption utility for AES encryption/decryption and MD5 hashing
/// 
/// Provides methods for:
/// - AES-256 encryption/decryption
/// - MD5 hashing for cache keys
/// - Base64 encoding/decoding
class EncryptionUtil {
  EncryptionUtil._();

  /// AES encrypt plaintext with given key
  /// 
  /// The key must be exactly 32 characters for AES-256.
  /// Returns base64-encoded encrypted string.
  /// 
  /// Example:
  /// ```dart
  /// final encrypted = EncryptionUtil.encryptAES(
  ///   'Hello World',
  ///   'my-32-character-encryption-key',
  /// );
  /// ```
  static String encryptAES(String plainText, String keyString) {
    try {
      // Validate key length
      if (keyString.length != 32) {
        throw EncryptionException(
          'Encryption key must be exactly 32 characters, got ${keyString.length}',
        );
      }

      // Create key and IV
      final key = Key.fromUtf8(keyString);
      final iv = IV.fromLength(16);

      // Create encrypter
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      // Encrypt
      final encrypted = encrypter.encrypt(plainText, iv: iv);

      return encrypted.base64;
    } catch (e, stackTrace) {
      if (e is EncryptionException) rethrow;
      throw EncryptionException(
        'Failed to encrypt data',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// AES decrypt encrypted string with given key
  /// 
  /// The encrypted string should be base64-encoded.
  /// The key must be exactly 32 characters for AES-256.
  /// 
  /// Example:
  /// ```dart
  /// final decrypted = EncryptionUtil.decryptAES(
  ///   encryptedBase64,
  ///   'my-32-character-encryption-key',
  /// );
  /// ```
  static String decryptAES(String encryptedBase64, String keyString) {
    try {
      // Validate key length
      if (keyString.length != 32) {
        throw EncryptionException(
          'Encryption key must be exactly 32 characters, got ${keyString.length}',
        );
      }

      // Create key and IV
      final key = Key.fromUtf8(keyString);
      final iv = IV.fromLength(16);

      // Create encrypter
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      // Decrypt
      final decrypted = encrypter.decrypt64(encryptedBase64, iv: iv);

      return decrypted;
    } catch (e, stackTrace) {
      if (e is EncryptionException) rethrow;
      throw EncryptionException(
        'Failed to decrypt data',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Generate MD5 hash of input string
  /// 
  /// Useful for generating cache keys from URLs and parameters.
  /// 
  /// Example:
  /// ```dart
  /// final cacheKey = EncryptionUtil.md5Hash('https://api.example.com/users');
  /// ```
  static String md5Hash(String input) {
    try {
      final bytes = utf8.encode(input);
      final digest = md5.convert(bytes);
      return digest.toString();
    } catch (e, stackTrace) {
      throw EncryptionException(
        'Failed to generate MD5 hash',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Generate SHA-256 hash of input string
  /// 
  /// More secure than MD5, useful for password hashing.
  /// 
  /// Example:
  /// ```dart
  /// final hash = EncryptionUtil.sha256Hash('password123');
  /// ```
  static String sha256Hash(String input) {
    try {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e, stackTrace) {
      throw EncryptionException(
        'Failed to generate SHA-256 hash',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Encode string to base64
  static String base64Encode(String input) {
    try {
      final bytes = utf8.encode(input);
      return base64.encode(bytes);
    } catch (e, stackTrace) {
      throw EncryptionException(
        'Failed to encode base64',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Decode base64 string
  static String base64Decode(String input) {
    try {
      final bytes = base64.decode(input);
      return utf8.decode(bytes);
    } catch (e, stackTrace) {
      throw EncryptionException(
        'Failed to decode base64',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Generate a random encryption key of specified length
  /// 
  /// Default length is 32 characters for AES-256.
  static String generateKey({int length = 32}) {
    final random = SecureRandom(length);
    return base64Url.encode(random.bytes).substring(0, length);
  }
}
