import '../../core/utils/validation_util.dart';

/// Email value object
/// 
/// Represents a validated email address in the domain layer
class Email {
  final String value;

  Email(this.value) {
    if (!ValidationUtil.isValidEmail(value)) {
      throw ArgumentError('Invalid email format');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Email &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
