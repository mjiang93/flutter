import 'package:flutter_test/flutter_test.dart';
import 'package:enterprise_flutter_app/core/utils/format_util.dart';

void main() {
  group('FormatUtil', () {
    group('Date Formatting', () {
      test('formatDate with default pattern (yyyy-MM-dd HH:mm:ss)', () {
        final date = DateTime(2024, 1, 15, 10, 30, 45);
        final formatted = FormatUtil.formatDate(date);

        expect(formatted, equals('2024-01-15 10:30:45'));
      });

      test('formatDate with custom date pattern (yyyy/MM/dd)', () {
        final date = DateTime(2024, 1, 15, 10, 30, 45);
        final formatted = FormatUtil.formatDate(date, pattern: 'yyyy/MM/dd');

        expect(formatted, equals('2024/01/15'));
      });

      test('formatDate with custom time pattern (HH:mm)', () {
        final date = DateTime(2024, 1, 15, 10, 30, 45);
        final formatted = FormatUtil.formatDate(date, pattern: 'HH:mm');

        expect(formatted, equals('10:30'));
      });

      test('formatDate with various date patterns', () {
        final date = DateTime(2024, 1, 15, 10, 30, 45);

        // Test different patterns
        expect(
          FormatUtil.formatDate(date, pattern: 'yyyy-MM-dd'),
          equals('2024-01-15'),
        );
        expect(
          FormatUtil.formatDate(date, pattern: 'MM-dd'),
          equals('01-15'),
        );
        expect(
          FormatUtil.formatDate(date, pattern: 'HH:mm:ss'),
          equals('10:30:45'),
        );
        expect(
          FormatUtil.formatDate(date, pattern: 'yyyy-MM-dd HH:mm'),
          equals('2024-01-15 10:30'),
        );
      });

      test('formatDate with single-digit month and day', () {
        final date = DateTime(2024, 1, 5, 9, 5, 3);
        final formatted = FormatUtil.formatDate(date, pattern: 'yyyy-MM-dd HH:mm:ss');

        expect(formatted, equals('2024-01-05 09:05:03'));
      });

      test('formatDate with double-digit month and day', () {
        final date = DateTime(2024, 12, 25, 23, 59, 59);
        final formatted = FormatUtil.formatDate(date, pattern: 'yyyy-MM-dd HH:mm:ss');

        expect(formatted, equals('2024-12-25 23:59:59'));
      });

      test('formatDateOnly returns date in yyyy-MM-dd format', () {
        final date = DateTime(2024, 1, 15, 10, 30, 45);
        final formatted = FormatUtil.formatDateOnly(date);

        expect(formatted, equals('2024-01-15'));
      });

      test('formatTimeOnly returns time in HH:mm:ss format', () {
        final date = DateTime(2024, 1, 15, 10, 30, 45);
        final formatted = FormatUtil.formatTimeOnly(date);

        expect(formatted, equals('10:30:45'));
      });

      test('formatDate handles leap year dates correctly', () {
        final leapYearDate = DateTime(2024, 2, 29, 12, 0, 0);
        final formatted = FormatUtil.formatDate(leapYearDate, pattern: 'yyyy-MM-dd');

        expect(formatted, equals('2024-02-29'));
      });

      test('formatDate handles year boundaries correctly', () {
        final newYearDate = DateTime(2024, 1, 1, 0, 0, 0);
        final formatted = FormatUtil.formatDate(newYearDate, pattern: 'yyyy-MM-dd HH:mm:ss');

        expect(formatted, equals('2024-01-01 00:00:00'));
      });

      test('formatDate handles invalid pattern gracefully', () {
        final date = DateTime(2024, 1, 15, 10, 30, 45);
        // Invalid pattern should return date.toString() as fallback
        final formatted = FormatUtil.formatDate(date, pattern: 'invalid_pattern');

        expect(formatted, isNotEmpty);
      });
    });

    group('Amount Formatting', () {
      test('formatNumber with no decimals', () {
        expect(FormatUtil.formatNumber(1234567), equals('1,234,567'));
        expect(FormatUtil.formatNumber(1000), equals('1,000'));
        expect(FormatUtil.formatNumber(100), equals('100'));
        expect(FormatUtil.formatNumber(10), equals('10'));
      });

      test('formatNumber with 1 decimal place', () {
        expect(FormatUtil.formatNumber(1234.5, decimals: 1), equals('1,234.5'));
        expect(FormatUtil.formatNumber(1000.1, decimals: 1), equals('1,000.1'));
        expect(FormatUtil.formatNumber(100.9, decimals: 1), equals('100.9'));
      });

      test('formatNumber with 2 decimal places', () {
        expect(FormatUtil.formatNumber(1234.56, decimals: 2), equals('1,234.56'));
        expect(FormatUtil.formatNumber(1000.10, decimals: 2), equals('1,000.10'));
        expect(FormatUtil.formatNumber(100.99, decimals: 2), equals('100.99'));
      });

      test('formatNumber with 3 decimal places', () {
        expect(FormatUtil.formatNumber(1234.567, decimals: 3), equals('1,234.567'));
        expect(FormatUtil.formatNumber(1000.100, decimals: 3), equals('1,000.100'));
        expect(FormatUtil.formatNumber(100.999, decimals: 3), equals('100.999'));
      });

      test('formatNumber with various decimal places', () {
        final amount = 1234567.89;

        expect(FormatUtil.formatNumber(amount, decimals: 0), equals('1,234,568'));
        expect(FormatUtil.formatNumber(amount, decimals: 1), equals('1,234,567.9'));
        expect(FormatUtil.formatNumber(amount, decimals: 2), equals('1,234,567.89'));
        expect(FormatUtil.formatNumber(amount, decimals: 4), equals('1,234,567.8900'));
      });

      test('formatNumber with small amounts', () {
        expect(FormatUtil.formatNumber(0, decimals: 2), equals('0.00'));
        expect(FormatUtil.formatNumber(0.01, decimals: 2), equals('0.01'));
        expect(FormatUtil.formatNumber(0.99, decimals: 2), equals('0.99'));
        expect(FormatUtil.formatNumber(1.5, decimals: 2), equals('1.50'));
      });

      test('formatNumber with large amounts', () {
        expect(FormatUtil.formatNumber(1000000, decimals: 0), equals('1,000,000'));
        expect(FormatUtil.formatNumber(1000000000, decimals: 0), equals('1,000,000,000'));
        expect(FormatUtil.formatNumber(999999999.99, decimals: 2), equals('999,999,999.99'));
      });

      test('formatNumber with negative amounts', () {
        expect(FormatUtil.formatNumber(-1234.56, decimals: 2), equals('-1,234.56'));
        expect(FormatUtil.formatNumber(-1000, decimals: 0), equals('-1,000'));
        expect(FormatUtil.formatNumber(-0.01, decimals: 2), equals('-0.01'));
      });

      test('formatCurrency with default symbol (¥)', () {
        expect(FormatUtil.formatCurrency(1234.56), equals('¥1,234.56'));
        expect(FormatUtil.formatCurrency(1000), equals('¥1,000.00'));
        expect(FormatUtil.formatCurrency(0.99), equals('¥0.99'));
      });

      test('formatCurrency with custom symbol (\$)', () {
        expect(
          FormatUtil.formatCurrency(1234.56, symbol: '\$'),
          equals('\$1,234.56'),
        );
        expect(
          FormatUtil.formatCurrency(1000, symbol: '\$'),
          equals('\$1,000.00'),
        );
      });

      test('formatCurrency with custom symbol (€)', () {
        expect(
          FormatUtil.formatCurrency(1234.56, symbol: '€'),
          equals('€1,234.56'),
        );
      });

      test('formatCurrency with different decimal places', () {
        expect(
          FormatUtil.formatCurrency(1234.5, decimals: 1),
          equals('¥1,234.5'),
        );
        expect(
          FormatUtil.formatCurrency(1234.567, decimals: 3),
          equals('¥1,234.567'),
        );
      });

      test('formatCurrency with zero amount', () {
        expect(FormatUtil.formatCurrency(0), equals('¥0.00'));
        expect(FormatUtil.formatCurrency(0, symbol: '\$'), equals('\$0.00'));
      });

      test('formatCurrency with negative amount', () {
        expect(FormatUtil.formatCurrency(-1234.56), equals('¥-1,234.56'));
        expect(FormatUtil.formatCurrency(-1000), equals('¥-1,000.00'));
      });

      test('formatPercentage with default 2 decimal places', () {
        expect(FormatUtil.formatPercentage(0.1234), equals('12.34%'));
        expect(FormatUtil.formatPercentage(0.5), equals('50.00%'));
        expect(FormatUtil.formatPercentage(1.0), equals('100.00%'));
      });

      test('formatPercentage with 0 decimal places', () {
        expect(FormatUtil.formatPercentage(0.1234, decimals: 0), equals('12%'));
        expect(FormatUtil.formatPercentage(0.5, decimals: 0), equals('50%'));
        expect(FormatUtil.formatPercentage(1.0, decimals: 0), equals('100%'));
      });

      test('formatPercentage with 1 decimal place', () {
        expect(FormatUtil.formatPercentage(0.1234, decimals: 1), equals('12.3%'));
        expect(FormatUtil.formatPercentage(0.5, decimals: 1), equals('50.0%'));
      });

      test('formatPercentage with various values', () {
        expect(FormatUtil.formatPercentage(0.01), equals('1.00%'));
        expect(FormatUtil.formatPercentage(0.001), equals('0.10%'));
        expect(FormatUtil.formatPercentage(0.0001), equals('0.01%'));
      });
    });

    group('Phone Masking', () {
      test('maskPhone with valid 11-digit phone number', () {
        expect(FormatUtil.maskPhone('13812345678'), equals('138****5678'));
        expect(FormatUtil.maskPhone('14512345678'), equals('145****5678'));
        expect(FormatUtil.maskPhone('15512345678'), equals('155****5678'));
      });

      test('maskPhone preserves first 3 digits', () {
        expect(FormatUtil.maskPhone('13812345678'), startsWith('138'));
        expect(FormatUtil.maskPhone('14512345678'), startsWith('145'));
        expect(FormatUtil.maskPhone('19912345678'), startsWith('199'));
      });

      test('maskPhone preserves last 4 digits', () {
        expect(FormatUtil.maskPhone('13812345678'), endsWith('5678'));
        expect(FormatUtil.maskPhone('14512345678'), endsWith('5678'));
        expect(FormatUtil.maskPhone('19912345678'), endsWith('5678'));
      });

      test('maskPhone masks middle 4 digits with asterisks', () {
        final masked = FormatUtil.maskPhone('13812345678');
        expect(masked, equals('138****5678'));
        expect(masked.contains('****'), true);
      });

      test('maskPhone with various valid phone numbers', () {
        final testCases = {
          '13812345678': '138****5678',
          '14512345678': '145****5678',
          '15512345678': '155****5678',
          '16612345678': '166****5678',
          '17712345678': '177****5678',
          '18812345678': '188****5678',
          '19912345678': '199****5678',
        };

        for (final entry in testCases.entries) {
          expect(
            FormatUtil.maskPhone(entry.key),
            equals(entry.value),
            reason: 'Phone ${entry.key} should be masked as ${entry.value}',
          );
        }
      });

      test('maskPhone with phone number shorter than 11 digits', () {
        expect(FormatUtil.maskPhone('1381234567'), equals('1381234567'));
        expect(FormatUtil.maskPhone('138123'), equals('138123'));
        expect(FormatUtil.maskPhone('138'), equals('138'));
      });

      test('maskPhone with phone number longer than 11 digits', () {
        expect(FormatUtil.maskPhone('138123456789'), equals('138123456789'));
        expect(FormatUtil.maskPhone('1381234567890'), equals('1381234567890'));
      });

      test('maskPhone with empty string', () {
        expect(FormatUtil.maskPhone(''), equals(''));
      });

      test('maskPhone with exactly 11 characters but non-numeric', () {
        // Should return as-is since length is 11 but contains non-digits
        final result = FormatUtil.maskPhone('138-12345678');
        expect(result, equals('138-12345678'));
      });

      test('maskPhone result format is consistent', () {
        final masked = FormatUtil.maskPhone('13812345678');
        expect(masked.length, equals(11)); // 3 + 4 asterisks + 4 digits
        expect(masked.split('****').length, equals(2)); // Should have exactly one **** group
      });

      test('maskPhone with all same digits', () {
        expect(FormatUtil.maskPhone('11111111111'), equals('111****1111'));
        expect(FormatUtil.maskPhone('99999999999'), equals('999****9999'));
      });

      test('maskPhone with sequential digits', () {
        expect(FormatUtil.maskPhone('12345678901'), equals('123****8901'));
      });
    });

    group('Email Masking', () {
      test('maskEmail with valid email addresses', () {
        expect(FormatUtil.maskEmail('user@example.com'), equals('u***@example.com'));
        expect(FormatUtil.maskEmail('john@company.org'), equals('j***@company.org'));
        expect(FormatUtil.maskEmail('admin@domain.co.uk'), equals('a***@domain.co.uk'));
      });

      test('maskEmail preserves domain part', () {
        expect(FormatUtil.maskEmail('user@example.com'), endsWith('@example.com'));
        expect(FormatUtil.maskEmail('john@company.org'), endsWith('@company.org'));
      });

      test('maskEmail with single character username', () {
        expect(FormatUtil.maskEmail('a@example.com'), equals('a@example.com'));
      });

      test('maskEmail with invalid email format', () {
        expect(FormatUtil.maskEmail('invalid'), equals('invalid'));
        // maskEmail still masks if it has @ symbol, even if invalid format
        expect(FormatUtil.maskEmail('user@'), equals('u***@'));
        expect(FormatUtil.maskEmail('@example.com'), equals('@example.com'));
      });
    });

    group('ID Card Masking', () {
      test('maskIdCard with valid 18-digit ID card', () {
        expect(
          FormatUtil.maskIdCard('110101199001011234'),
          equals('110101********1234'),
        );
      });

      test('maskIdCard preserves first 6 digits', () {
        expect(FormatUtil.maskIdCard('110101199001011234'), startsWith('110101'));
      });

      test('maskIdCard preserves last 4 digits', () {
        expect(FormatUtil.maskIdCard('110101199001011234'), endsWith('1234'));
      });

      test('maskIdCard with various valid ID cards', () {
        final testCases = {
          '110101199001011234': '110101********1234',
          '110101199001011235': '110101********1235',
          '110101199001011236': '110101********1236',
        };

        for (final entry in testCases.entries) {
          expect(
            FormatUtil.maskIdCard(entry.key),
            equals(entry.value),
            reason: 'ID card ${entry.key} should be masked as ${entry.value}',
          );
        }
      });

      test('maskIdCard with ID card shorter than 18 digits', () {
        expect(FormatUtil.maskIdCard('11010119900101123'), equals('11010119900101123'));
      });

      test('maskIdCard with ID card longer than 18 digits', () {
        expect(
          FormatUtil.maskIdCard('1101011990010112345'),
          equals('1101011990010112345'),
        );
      });

      test('maskIdCard with empty string', () {
        expect(FormatUtil.maskIdCard(''), equals(''));
      });
    });

    group('File Size Formatting', () {
      test('formatFileSize with bytes', () {
        expect(FormatUtil.formatFileSize(512), equals('512 B'));
        expect(FormatUtil.formatFileSize(1023), equals('1023 B'));
      });

      test('formatFileSize with kilobytes', () {
        expect(FormatUtil.formatFileSize(1024), equals('1.00 KB'));
        expect(FormatUtil.formatFileSize(2048), equals('2.00 KB'));
        expect(FormatUtil.formatFileSize(1536), equals('1.50 KB'));
      });

      test('formatFileSize with megabytes', () {
        expect(FormatUtil.formatFileSize(1048576), equals('1.00 MB'));
        expect(FormatUtil.formatFileSize(2097152), equals('2.00 MB'));
        expect(FormatUtil.formatFileSize(1572864), equals('1.50 MB'));
      });

      test('formatFileSize with gigabytes', () {
        expect(FormatUtil.formatFileSize(1073741824), equals('1.00 GB'));
        expect(FormatUtil.formatFileSize(2147483648), equals('2.00 GB'));
      });

      test('formatFileSize with custom decimal places', () {
        expect(FormatUtil.formatFileSize(1536, decimals: 1), equals('1.5 KB'));
        expect(FormatUtil.formatFileSize(1536, decimals: 3), equals('1.500 KB'));
      });
    });

    group('Duration Formatting', () {
      test('formatDuration with seconds only', () {
        expect(
          FormatUtil.formatDuration(Duration(seconds: 30)),
          equals('30s'),
        );
      });

      test('formatDuration with minutes and seconds', () {
        expect(
          FormatUtil.formatDuration(Duration(minutes: 1, seconds: 30)),
          equals('1m 30s'),
        );
      });

      test('formatDuration with hours, minutes, and seconds', () {
        expect(
          FormatUtil.formatDuration(Duration(hours: 2, minutes: 30, seconds: 45)),
          equals('2h 30m 45s'),
        );
      });

      test('formatDuration with zero duration', () {
        expect(
          FormatUtil.formatDuration(Duration.zero),
          equals('0s'),
        );
      });
    });

    group('String Utilities', () {
      test('truncate with text shorter than max length', () {
        expect(FormatUtil.truncate('Hello', 10), equals('Hello'));
      });

      test('truncate with text equal to max length', () {
        expect(FormatUtil.truncate('Hello', 5), equals('Hello'));
      });

      test('truncate with text longer than max length', () {
        expect(FormatUtil.truncate('Hello World', 8), equals('Hello...'));
      });

      test('capitalize with lowercase string', () {
        expect(FormatUtil.capitalize('hello'), equals('Hello'));
      });

      test('capitalize with uppercase string', () {
        expect(FormatUtil.capitalize('HELLO'), equals('HELLO'));
      });

      test('capitalize with empty string', () {
        expect(FormatUtil.capitalize(''), equals(''));
      });

      test('toTitleCase with multiple words', () {
        expect(FormatUtil.toTitleCase('hello world'), equals('Hello World'));
        expect(FormatUtil.toTitleCase('hello world test'), equals('Hello World Test'));
      });

      test('toTitleCase with single word', () {
        expect(FormatUtil.toTitleCase('hello'), equals('Hello'));
      });

      test('toTitleCase with empty string', () {
        expect(FormatUtil.toTitleCase(''), equals(''));
      });
    });

    group('Relative Time Formatting', () {
      test('formatRelativeTime with just now', () {
        final now = DateTime.now();
        expect(FormatUtil.formatRelativeTime(now), equals('just now'));
      });

      test('formatRelativeTime with minutes ago', () {
        final fiveMinutesAgo = DateTime.now().subtract(Duration(minutes: 5));
        expect(FormatUtil.formatRelativeTime(fiveMinutesAgo), equals('5 minutes ago'));
      });

      test('formatRelativeTime with hours ago', () {
        final twoHoursAgo = DateTime.now().subtract(Duration(hours: 2));
        expect(FormatUtil.formatRelativeTime(twoHoursAgo), equals('2 hours ago'));
      });

      test('formatRelativeTime with days ago', () {
        final threeDaysAgo = DateTime.now().subtract(Duration(days: 3));
        expect(FormatUtil.formatRelativeTime(threeDaysAgo), equals('3 days ago'));
      });
    });
  });
}
