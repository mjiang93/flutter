import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

/// User entity representing a user in the domain layer
/// 
/// This is a pure domain model with no dependencies on external frameworks
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String nickname,
    required String phone,
    String? avatar,
    String? email,
    @Default(false) bool isVip,
    DateTime? createdAt,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
