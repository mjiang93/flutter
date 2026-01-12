/// Dart core type extensions
/// 
/// Provides convenient extension methods for:
/// - String
/// - int
/// - double
/// - DateTime
/// - List
/// - Map

// String extensions
extension StringExtension on String {
  /// Check if string is empty or null
  bool get isNullOrEmpty => isEmpty;

  /// Check if string is not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Check if string is blank (empty or whitespace)
  bool get isBlank => trim().isEmpty;

  /// Check if string is not blank
  bool get isNotBlank => trim().isNotEmpty;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Convert to title case
  String get toTitleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Check if string is numeric
  bool get isNumeric => double.tryParse(this) != null;

  /// Check if string is integer
  bool get isInteger => int.tryParse(this) != null;

  /// Convert to int safely
  int? get toIntOrNull => int.tryParse(this);

  /// Convert to double safely
  double? get toDoubleOrNull => double.tryParse(this);

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Reverse string
  String get reverse => split('').reversed.join();

  /// Check if string contains only letters
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Check if string contains only letters and digits
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Convert string to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Convert string to camelCase
  String get toCamelCase {
    final words = split('_');
    if (words.isEmpty) return this;
    return words.first +
        words.skip(1).map((word) => word.capitalize).join();
  }

  /// Convert string to PascalCase
  String get toPascalCase {
    return split('_').map((word) => word.capitalize).join();
  }

  /// Mask string (show first and last n characters)
  String mask({int start = 1, int end = 1, String mask = '*'}) {
    if (length <= start + end) return this;
    final masked = mask * (length - start - end);
    return '${substring(0, start)}$masked${substring(length - end)}';
  }
}

// int extensions
extension IntExtension on int {
  /// Check if number is even
  bool get isEven => this % 2 == 0;

  /// Check if number is odd
  bool get isOdd => this % 2 != 0;

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Convert to duration in seconds
  Duration get seconds => Duration(seconds: this);

  /// Convert to duration in minutes
  Duration get minutes => Duration(minutes: this);

  /// Convert to duration in hours
  Duration get hours => Duration(hours: this);

  /// Convert to duration in days
  Duration get days => Duration(days: this);

  /// Format with thousand separator
  String get formatted {
    final str = toString();
    final buffer = StringBuffer();
    var count = 0;

    for (var i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
      count++;
    }

    return buffer.toString().split('').reversed.join();
  }

  /// Convert bytes to human-readable size
  String get toFileSize {
    if (this < 1024) {
      return '$this B';
    } else if (this < 1024 * 1024) {
      return '${(this / 1024).toStringAsFixed(2)} KB';
    } else if (this < 1024 * 1024 * 1024) {
      return '${(this / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  /// Clamp value between min and max
  int clampValue(int min, int max) => clamp(min, max).toInt();

  /// Check if value is in range (inclusive)
  bool inRange(int min, int max) => this >= min && this <= max;
}

// double extensions
extension DoubleExtension on double {
  /// Round to n decimal places
  double roundToDecimal(int places) {
    final mod = 10.0 * places;
    return (this * mod).round() / mod;
  }

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Format as percentage
  String toPercentage({int decimals = 2}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }

  /// Format as currency
  String toCurrency({String symbol = '¥', int decimals = 2}) {
    return '$symbol${toStringAsFixed(decimals)}';
  }

  /// Clamp value between min and max
  double clampValue(double min, double max) => clamp(min, max).toDouble();

  /// Check if value is in range (inclusive)
  bool inRange(double min, double max) => this >= min && this <= max;
}

// DateTime extensions
extension DateTimeExtension on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Get start of day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59);

  /// Add days
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Get difference in days
  int differenceInDays(DateTime other) {
    return difference(other).inDays;
  }

  /// Get difference in hours
  int differenceInHours(DateTime other) {
    return difference(other).inHours;
  }

  /// Get difference in minutes
  int differenceInMinutes(DateTime other) {
    return difference(other).inMinutes;
  }

  /// Format as relative time
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

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
}

// List extensions
extension ListExtension<T> on List<T> {
  /// Check if list is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if list is not null or empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Get first element or null
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null
  T? get lastOrNull => isEmpty ? null : last;

  /// Get element at index or null
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Chunk list into smaller lists
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }

  /// Remove duplicates
  List<T> get unique => toSet().toList();

  /// Shuffle list (returns new list)
  List<T> get shuffled => [...this]..shuffle();

  /// Group by key
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keyFunction(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }
}

// Map extensions
extension MapExtension<K, V> on Map<K, V> {
  /// Check if map is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if map is not null or empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Get value or default
  V getOrDefault(K key, V defaultValue) {
    return this[key] ?? defaultValue;
  }

  /// Get value or compute default
  V getOrElse(K key, V Function() defaultValue) {
    return this[key] ?? defaultValue();
  }

  /// Filter map by predicate
  Map<K, V> filter(bool Function(K key, V value) predicate) {
    return Map.fromEntries(
      entries.where((entry) => predicate(entry.key, entry.value)),
    );
  }

  /// Map values
  Map<K, V2> mapValues<V2>(V2 Function(K key, V value) transform) {
    return map((key, value) => MapEntry(key, transform(key, value)));
  }
}
