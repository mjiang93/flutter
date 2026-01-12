import 'package:intl/intl.dart';

/// Formatting utility for common data formatting
/// 
/// Provides formatting methods for:
/// - Dates and times
/// - Numbers and currency
/// - Phone numbers
/// - File sizes
class FormatUtil {
  FormatUtil._();

  // Date format patterns
  static const String datePattern = 'yyyy-MM-dd';
  static const String timePattern = 'HH:mm:ss';
  static const String dateTimePattern = 'yyyy-MM-dd HH:mm:ss';
  static const String dateTimeMinutePattern = 'yyyy-MM-dd HH:mm';
  static const String monthDayPattern = 'MM-dd';
  static const String hourMinutePattern = 'HH:mm';

  /// Format DateTime to string with custom pattern
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.formatDate(DateTime.now()); // '2024-01-15 10:30:45'
  /// FormatUtil.formatDate(DateTime.now(), pattern: 'yyyy/MM/dd'); // '2024/01/15'
  /// ```
  static String formatDate(
    DateTime date, {
    String pattern = dateTimePattern,
  }) {
    try {
      return DateFormat(pattern).format(date);
    } catch (e) {
      return date.toString();
    }
  }

  /// Format DateTime to date only (yyyy-MM-dd)
  static String formatDateOnly(DateTime date) {
    return formatDate(date, pattern: datePattern);
  }

  /// Format DateTime to time only (HH:mm:ss)
  static String formatTimeOnly(DateTime date) {
    return formatDate(date, pattern: timePattern);
  }

  /// Format DateTime to relative time (e.g., "2 hours ago", "just now")
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.formatRelativeTime(DateTime.now()); // 'just now'
  /// FormatUtil.formatRelativeTime(DateTime.now().subtract(Duration(hours: 2))); // '2 hours ago'
  /// ```
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  /// Format number with thousand separator
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.formatNumber(1234567); // '1,234,567'
  /// FormatUtil.formatNumber(1234.56, decimals: 2); // '1,234.56'
  /// ```
  static String formatNumber(num number, {int decimals = 0}) {
    try {
      final pattern = decimals > 0 ? '#,##0.${'0' * decimals}' : '#,##0';
      return NumberFormat(pattern).format(number);
    } catch (e) {
      return number.toString();
    }
  }

  /// Format amount as currency
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.formatCurrency(1234.56); // '¥1,234.56'
  /// FormatUtil.formatCurrency(1234.56, symbol: '\$'); // '\$1,234.56'
  /// ```
  static String formatCurrency(
    num amount, {
    String symbol = '¥',
    int decimals = 2,
  }) {
    final formatted = formatNumber(amount, decimals: decimals);
    return '$symbol$formatted';
  }

  /// Format percentage
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.formatPercentage(0.1234); // '12.34%'
  /// FormatUtil.formatPercentage(0.5, decimals: 0); // '50%'
  /// ```
  static String formatPercentage(num value, {int decimals = 2}) {
    final percentage = value * 100;
    return '${formatNumber(percentage, decimals: decimals)}%';
  }

  /// Mask phone number (e.g., 138****1234)
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.maskPhone('13812345678'); // '138****5678'
  /// ```
  static String maskPhone(String phone) {
    if (phone.length != 11) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(7)}';
  }

  /// Mask email (e.g., u***@example.com)
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.maskEmail('user@example.com'); // 'u***@example.com'
  /// ```
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 1) return email;

    final masked = '${username[0]}***';
    return '$masked@$domain';
  }

  /// Mask ID card (e.g., 110101********1234)
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.maskIdCard('110101199001011234'); // '110101********1234'
  /// ```
  static String maskIdCard(String idCard) {
    if (idCard.length != 18) return idCard;
    return '${idCard.substring(0, 6)}********${idCard.substring(14)}';
  }

  /// Format file size in human-readable format
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.formatFileSize(1024); // '1.00 KB'
  /// FormatUtil.formatFileSize(1048576); // '1.00 MB'
  /// ```
  static String formatFileSize(int bytes, {int decimals = 2}) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(decimals)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      final mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(decimals)} MB';
    } else {
      final gb = bytes / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(decimals)} GB';
    }
  }

  /// Format duration in human-readable format
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.formatDuration(Duration(hours: 2, minutes: 30)); // '2h 30m'
  /// FormatUtil.formatDuration(Duration(seconds: 90)); // '1m 30s'
  /// ```
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final parts = <String>[];
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0 || parts.isEmpty) parts.add('${seconds}s');

    return parts.join(' ');
  }

  /// Truncate string with ellipsis
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.truncate('Hello World', 8); // 'Hello...'
  /// ```
  static String truncate(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Capitalize first letter of string
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.capitalize('hello'); // 'Hello'
  /// ```
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  /// Convert string to title case
  /// 
  /// Example:
  /// ```dart
  /// FormatUtil.toTitleCase('hello world'); // 'Hello World'
  /// ```
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
}
