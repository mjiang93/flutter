/// UserId value object
/// 
/// Represents a validated user identifier in the domain layer
class UserId {
  final String value;

  UserId(this.value) {
    if (value.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
