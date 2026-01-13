import 'package:flutter_test/flutter_test.dart';
import 'package:enterprise_flutter_app/core/utils/encryption_util.dart';

void main() {
  group('EncryptionUtil', () {
    // Property 10: Sensitive Data Encryption
    // For any sensitive data (token, password, API keys), when encrypted with AES,
    // the encrypted data should not be readable in plain text.
    // **Validates: Requirements 4.3**
    group('Property 10: Sensitive Data Encryption', () {
      const testKey = '12345678901234567890123456789012'; // 32 chars for AES-256

      // Test data representing various sensitive data types
      final sensitiveDataExamples = [
        'token_abc123def456',
        'password_SecureP@ss123',
        'api_key_sk_live_1234567890abcdef',
        'refresh_token_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
        'secret_key_with_special_chars_!@#\$%^&*()',
        'very_long_sensitive_data_' * 10, // Long data
        '{"token":"abc123","secret":"xyz789"}', // JSON data
      ];

      test(
        'encrypted data should not be readable in plain text',
        () {
          for (final sensitiveData in sensitiveDataExamples) {
            // Encrypt the sensitive data
            final encrypted = EncryptionUtil.encryptAES(sensitiveData, testKey);

            // Verify encrypted data is not the same as plain text
            expect(encrypted, isNot(sensitiveData));

            // Verify encrypted data is base64-encoded (contains only valid base64 chars)
            expect(
              RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(encrypted),
              true,
              reason: 'Encrypted data should be valid base64',
            );

            // Verify encrypted data is not empty
            expect(encrypted.isNotEmpty, true);

            // Verify encrypted data is longer than original (due to encryption overhead)
            expect(
              encrypted.length > sensitiveData.length,
              true,
              reason: 'Encrypted data should be longer due to encryption overhead',
            );
          }
        },
      );

      test(
        'encryption produces non-deterministic output due to random IV',
        () {
          const sensitiveData = 'token_abc123def456';

          // Encrypt the same data multiple times
          final encrypted1 = EncryptionUtil.encryptAES(sensitiveData, testKey);
          final encrypted2 = EncryptionUtil.encryptAES(sensitiveData, testKey);
          final encrypted3 = EncryptionUtil.encryptAES(sensitiveData, testKey);

          // Due to random IV, encrypted outputs should be different
          expect(encrypted1, isNot(encrypted2));
          expect(encrypted2, isNot(encrypted3));
          expect(encrypted1, isNot(encrypted3));

          // All encrypted outputs should be valid base64
          expect(RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(encrypted1), true);
          expect(RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(encrypted2), true);
          expect(RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(encrypted3), true);
        },
      );

      test(
        'different keys produce different encrypted outputs for same data',
        () {
          const sensitiveData = 'token_abc123def456';
          const key1 = '12345678901234567890123456789012';
          const key2 = '98765432109876543210987654321098';

          // Encrypt with different keys
          final encrypted1 = EncryptionUtil.encryptAES(sensitiveData, key1);
          final encrypted2 = EncryptionUtil.encryptAES(sensitiveData, key2);

          // Encrypted outputs should be different
          expect(encrypted1, isNot(encrypted2));

          // Both should be valid base64
          expect(RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(encrypted1), true);
          expect(RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(encrypted2), true);
        },
      );

      test(
        'encryption handles special characters and unicode correctly',
        () {
          final specialDataExamples = [
            'token_with_special_!@#\$%^&*()',
            'password_with_unicode_你好世界',
            'api_key_with_emoji_🔐🔑🛡️',
            'mixed_data_!@#\$%^&*()_+-=[]{}|;:,.<>?',
          ];

          for (final sensitiveData in specialDataExamples) {
            final encrypted = EncryptionUtil.encryptAES(sensitiveData, testKey);

            // Verify encrypted data is not the same as plain text
            expect(encrypted, isNot(sensitiveData));

            // Verify encrypted data is valid base64
            expect(
              RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(encrypted),
              true,
              reason: 'Encrypted data should be valid base64',
            );

            // Verify encrypted data is not empty
            expect(encrypted.isNotEmpty, true);
          }
        },
      );

      test(
        'encryption handles various data sizes correctly',
        () {
          // Test with various data sizes
          final dataSizes = [1, 10, 100, 1000, 10000];

          for (final size in dataSizes) {
            final sensitiveData = 'x' * size;

            // Encrypt the data
            final encrypted = EncryptionUtil.encryptAES(sensitiveData, testKey);

            // Verify encrypted data is not the same as plain text
            expect(encrypted, isNot(sensitiveData));

            // Verify encrypted data is valid base64
            expect(
              RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(encrypted),
              true,
              reason: 'Encrypted data should be valid base64',
            );

            // Verify encrypted data is not empty
            expect(encrypted.isNotEmpty, true);
          }
        },
      );

      test(
        'encryption requires exactly 32-character key',
        () {
          const sensitiveData = 'token_abc123def456';
          const validKey = '12345678901234567890123456789012'; // 32 chars
          const shortKey = '123456789012345678901234567890'; // 30 chars
          const longKey = '123456789012345678901234567890123'; // 33 chars

          // Valid key should work
          expect(
            () => EncryptionUtil.encryptAES(sensitiveData, validKey),
            returnsNormally,
          );

          // Invalid key lengths should throw
          expect(
            () => EncryptionUtil.encryptAES(sensitiveData, shortKey),
            throwsA(isA<Exception>()),
          );

          expect(
            () => EncryptionUtil.encryptAES(sensitiveData, longKey),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    // Additional tests for MD5 hashing
    group('MD5 Hashing', () {
      test('md5Hash produces consistent output for same input', () {
        const input = 'https://api.example.com/users';

        final hash1 = EncryptionUtil.md5Hash(input);
        final hash2 = EncryptionUtil.md5Hash(input);

        expect(hash1, equals(hash2));
      });

      test('md5Hash produces different output for different inputs', () {
        final hash1 = EncryptionUtil.md5Hash('input1');
        final hash2 = EncryptionUtil.md5Hash('input2');

        expect(hash1, isNot(hash2));
      });

      test('md5Hash produces valid hex string', () {
        const input = 'test_data';
        final hash = EncryptionUtil.md5Hash(input);

        // MD5 hash should be 32 hex characters
        expect(hash.length, equals(32));
        expect(RegExp(r'^[a-f0-9]{32}$').hasMatch(hash), true);
      });
    });

    // Additional tests for Base64 encoding/decoding
    group('Base64 Encoding/Decoding', () {
      test('base64 round-trip preserves data', () {
        const testData = 'Hello World! 你好世界 🌍';

        final encoded = EncryptionUtil.base64Encode(testData);
        final decoded = EncryptionUtil.base64Decode(encoded);

        expect(decoded, equals(testData));
      });

      test('base64 encoding produces valid base64 string', () {
        const testData = 'sensitive_data_123';

        final encoded = EncryptionUtil.base64Encode(testData);

        // Should be valid base64
        expect(
          RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(encoded),
          true,
        );
      });
    });
  });
}
