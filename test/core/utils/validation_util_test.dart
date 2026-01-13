import 'package:flutter_test/flutter_test.dart';
import 'package:enterprise_flutter_app/core/utils/validation_util.dart';

void main() {
  group('ValidationUtil', () {
    group('Phone Number Validation', () {
      test('valid Chinese mobile phone numbers should return true', () {
        final validPhones = [
          '13812345678',
          '14512345678',
          '15512345678',
          '16612345678',
          '17712345678',
          '18812345678',
          '19912345678',
        ];

        for (final phone in validPhones) {
          expect(
            ValidationUtil.isValidPhone(phone),
            true,
            reason: '$phone should be valid',
          );
        }
      });

      test('invalid phone numbers should return false', () {
        final invalidPhones = [
          '12345678901', // Starts with 1 but second digit is 2
          '11812345678', // Starts with 11
          '13812345', // Too short
          '138123456789', // Too long
          '1381234567a', // Contains letter
          '138 12345678', // Contains space
          '138-12345678', // Contains dash
          '', // Empty string
          '   ', // Whitespace
          '0138123456', // Starts with 0
          '2138123456', // Starts with 2
        ];

        for (final phone in invalidPhones) {
          expect(
            ValidationUtil.isValidPhone(phone),
            false,
            reason: '$phone should be invalid',
          );
        }
      });

      test('phone validation should be case-sensitive for letters', () {
        expect(ValidationUtil.isValidPhone('138123456A8'), false);
        expect(ValidationUtil.isValidPhone('138123456a8'), false);
      });
    });

    group('Email Validation', () {
      test('valid email addresses should return true', () {
        final validEmails = [
          'user@example.com',
          'john.doe@company.co.uk',
          'test+tag@domain.org',
          'user_name@example.com',
          'user-name@example.com',
          'user123@example.com',
          'a@b.co',
          'test@subdomain.example.com',
        ];

        for (final email in validEmails) {
          expect(
            ValidationUtil.isValidEmail(email),
            true,
            reason: '$email should be valid',
          );
        }
      });

      test('invalid email addresses should return false', () {
        final invalidEmails = [
          'plainaddress', // No @ symbol
          '@example.com', // No local part
          'user@', // No domain
          'user@.com', // No domain name
          'user@domain', // No TLD
          'user @example.com', // Space in local part
          'user@exam ple.com', // Space in domain
          'user@@example.com', // Double @
          '', // Empty string
          'user@example.c', // TLD too short
        ];

        for (final email in invalidEmails) {
          expect(
            ValidationUtil.isValidEmail(email),
            false,
            reason: '$email should be invalid',
          );
        }
      });

      test('email validation should be case-insensitive', () {
        expect(ValidationUtil.isValidEmail('User@Example.COM'), true);
        expect(ValidationUtil.isValidEmail('USER@EXAMPLE.COM'), true);
        expect(ValidationUtil.isValidEmail('user@example.com'), true);
      });
    });

    group('ID Card Validation', () {
      test('valid Chinese ID card numbers should return true', () {
        final validIdCards = [
          '110101199001011234', // 18 digits
          '110101199001011235',
          '110101199001011236',
          '110101199001011237',
          '110101199001011238',
          '110101199001011239',
          '110101199001011230',
          '110101199001011231',
          '110101199001011232',
        ];

        for (final idCard in validIdCards) {
          expect(
            ValidationUtil.isValidIdCard(idCard),
            true,
            reason: '$idCard should be valid',
          );
        }
      });

      test('invalid ID card numbers should return false', () {
        final invalidIdCards = [
          '11010119900101123', // Only 17 digits
          '1101011990010112345', // 19 digits
          '11010119900101123a', // Contains lowercase letter (not X)
          '11010119900101123A', // Contains uppercase letter (not X)
          '1101011990010112 4', // Contains space
          '110101199001011-34', // Contains dash
          '', // Empty string
          '   ', // Whitespace
          'abcdefghijklmnopqr', // All letters
          '110101199001011234567', // Too long
        ];

        for (final idCard in invalidIdCards) {
          expect(
            ValidationUtil.isValidIdCard(idCard),
            false,
            reason: '$idCard should be invalid',
          );
        }
      });

      test('ID card validation should reject X or x as last digit', () {
        expect(ValidationUtil.isValidIdCard('110101199001011231X'), false);
        expect(ValidationUtil.isValidIdCard('110101199001011231x'), false);
      });

      test('ID card validation should reject other letters as last digit', () {
        expect(ValidationUtil.isValidIdCard('110101199001011231Y'), false);
        expect(ValidationUtil.isValidIdCard('110101199001011231y'), false);
        expect(ValidationUtil.isValidIdCard('110101199001011231Z'), false);
      });
    });

    group('Edge Cases', () {
      test('validation methods should handle null-like strings', () {
        expect(ValidationUtil.isValidPhone(''), false);
        expect(ValidationUtil.isValidEmail(''), false);
        expect(ValidationUtil.isValidIdCard(''), false);
      });

      test('validation methods should handle whitespace-only strings', () {
        expect(ValidationUtil.isValidPhone('   '), false);
        expect(ValidationUtil.isValidEmail('   '), false);
        expect(ValidationUtil.isValidIdCard('   '), false);
      });

      test('validation methods should handle very long strings', () {
        final longString = 'a' * 1000;
        expect(ValidationUtil.isValidPhone(longString), false);
        expect(ValidationUtil.isValidEmail(longString), false);
        expect(ValidationUtil.isValidIdCard(longString), false);
      });

      test('validation methods should handle special characters', () {
        expect(ValidationUtil.isValidPhone('138!@#\$%^&*()'), false);
        expect(ValidationUtil.isValidEmail('user!@#\$%@example.com'), false);
        expect(ValidationUtil.isValidIdCard('11010119900101!@#\$'), false);
      });

      test('validation methods should handle unicode characters', () {
        expect(ValidationUtil.isValidPhone('138你好345678'), false);
        expect(ValidationUtil.isValidEmail('用户@example.com'), false);
        expect(ValidationUtil.isValidIdCard('110101199001011你好'), false);
      });
    });

    group('Boundary Cases', () {
      test('phone number with exactly 11 digits should validate correctly', () {
        expect(ValidationUtil.isValidPhone('13812345678'), true); // Valid
        expect(ValidationUtil.isValidPhone('1381234567'), false); // 10 digits
        expect(ValidationUtil.isValidPhone('138123456789'), false); // 12 digits
      });

      test('email with minimum valid format should validate', () {
        expect(ValidationUtil.isValidEmail('a@b.co'), true);
        expect(ValidationUtil.isValidEmail('a@b.c'), false); // TLD too short
      });

      test('ID card with exactly 18 characters should validate correctly', () {
        expect(ValidationUtil.isValidIdCard('110101199001011234'), true); // 18 chars
        expect(ValidationUtil.isValidIdCard('11010119900101123'), false); // 17 chars
        expect(ValidationUtil.isValidIdCard('1101011990010112345'), false); // 19 chars
      });
    });
  });
}
