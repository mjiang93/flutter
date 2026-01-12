/// Validation utility for common input validation
/// 
/// Provides validation methods for:
/// - Phone numbers (Chinese mobile)
/// - Email addresses
/// - ID cards (Chinese)
/// - Passwords
/// - Usernames
class ValidationUtil {
  ValidationUtil._();

  /// Validate Chinese mobile phone number
  /// 
  /// Format: 1[3-9]xxxxxxxxx (11 digits starting with 1)
  /// 
  /// Example:
  /// ```dart
  /// ValidationUtil.isValidPhone('13812345678'); // true
  /// ValidationUtil.isValidPhone('12345678901'); // false
  /// ```
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;

    // Chinese mobile phone pattern: 1[3-9]xxxxxxxxx
    final regex = RegExp(r'^1[3-9]\d{9}$');
    return regex.hasMatch(phone);
  }

  /// Validate email address
  /// 
  /// Follows RFC 5322 simplified pattern.
  /// 
  /// Example:
  /// ```dart
  /// ValidationUtil.isValidEmail('user@example.com'); // true
  /// ValidationUtil.isValidEmail('invalid.email'); // false
  /// ```
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;

    // Email pattern
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(email);
  }

  /// Validate Chinese ID card number
  /// 
  /// Format: 18 digits, last digit can be X
  /// 
  /// Example:
  /// ```dart
  /// ValidationUtil.isValidIdCard('110101199001011234'); // true (format only)
  /// ValidationUtil.isValidIdCard('12345'); // false
  /// ```
  static bool isValidIdCard(String idCard) {
    if (idCard.isEmpty) return false;

    // Chinese ID card pattern: 18 digits, last can be X
    final regex = RegExp(r'^\d{17}[\dXx]$');
    return regex.hasMatch(idCard);
  }

  /// Validate password strength
  /// 
  /// Requirements:
  /// - Length between 6 and 20 characters
  /// - At least one letter
  /// - At least one digit
  /// 
  /// Example:
  /// ```dart
  /// ValidationUtil.isValidPassword('abc123'); // true
  /// ValidationUtil.isValidPassword('12345'); // false (no letter)
  /// ```
  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    if (password.length < 6 || password.length > 20) return false;

    // Must contain at least one letter and one digit
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);

    return hasLetter && hasDigit;
  }

  /// Validate username
  /// 
  /// Requirements:
  /// - Length between 3 and 20 characters
  /// - Only letters, digits, and underscores
  /// - Must start with a letter
  /// 
  /// Example:
  /// ```dart
  /// ValidationUtil.isValidUsername('user_123'); // true
  /// ValidationUtil.isValidUsername('123user'); // false (starts with digit)
  /// ```
  static bool isValidUsername(String username) {
    if (username.isEmpty) return false;
    if (username.length < 3 || username.length > 20) return false;

    // Must start with letter, contain only letters, digits, underscores
    final regex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');
    return regex.hasMatch(username);
  }

  /// Validate URL
  /// 
  /// Checks if string is a valid HTTP/HTTPS URL.
  /// 
  /// Example:
  /// ```dart
  /// ValidationUtil.isValidUrl('https://example.com'); // true
  /// ValidationUtil.isValidUrl('not a url'); // false
  /// ```
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Validate if string is numeric
  /// 
  /// Example:
  /// ```dart
  /// ValidationUtil.isNumeric('123'); // true
  /// ValidationUtil.isNumeric('12.34'); // true
  /// ValidationUtil.isNumeric('abc'); // false
  /// ```
  static bool isNumeric(String str) {
    if (str.isEmpty) return false;
    return double.tryParse(str) != null;
  }

  /// Validate if string is integer
  /// 
  /// Example:
  /// ```dart
  /// ValidationUtil.isInteger('123'); // true
  /// ValidationUtil.isInteger('12.34'); // false
  /// ```
  static bool isInteger(String str) {
    if (str.isEmpty) return false;
    return int.tryParse(str) != null;
  }

  /// Validate if string contains only letters
  /// 
  /// Example:
  /// ```dart
  /// ValidationUtil.isAlpha('abc'); // true
  /// ValidationUtil.isAlpha('abc123'); // false
  /// ```
  static bool isAlpha(String str) {
    if (str.isEmpty) return false;
    final regex = RegExp(r'^[a-zA-Z]+$');
    return regex.hasMatch(str);
  }

  /// Validate if string contains only letters and digits
  /// 
  /// Example:
  /// ```dart
  /// ValidationUtil.isAlphanumeric('abc123'); // true
  /// ValidationUtil.isAlphanumeric('abc-123'); // false
  /// ```
  static bool isAlphanumeric(String str) {
    if (str.isEmpty) return false;
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    return regex.hasMatch(str);
  }

  /// Validate string length
  /// 
  /// Example:
  /// ```dart
  /// ValidationUtil.isLengthBetween('hello', 3, 10); // true
  /// ValidationUtil.isLengthBetween('hi', 3, 10); // false
  /// ```
  static bool isLengthBetween(String str, int min, int max) {
    return str.length >= min && str.length <= max;
  }

  /// Validate if string is not empty or whitespace
  /// 
  /// Example:
  /// ```dart
  /// ValidationUtil.isNotBlank('hello'); // true
  /// ValidationUtil.isNotBlank('   '); // false
  /// ```
  static bool isNotBlank(String str) {
    return str.trim().isNotEmpty;
  }
}
