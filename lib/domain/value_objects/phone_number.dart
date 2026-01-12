import '../../core/utils/validation_util.dart';
import '../../core/utils/format_util.dart';

/// PhoneNumber value object
/// 
/// Represents a validated phone number in the domain layer
class PhoneNumber {
  final String value;

  PhoneNumber(this.value) {
    if (!ValidationUtil.isValidPhone(value)) {
      throw ArgumentError('Invalid phone number format');
    }
  }

  /// Get masked phone number (e.g., 138****1234)
  String get masked => FormatUtil.maskPhone(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
