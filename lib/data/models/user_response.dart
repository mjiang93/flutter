import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_response.freezed.dart';
part 'user_response.g.dart';

/// User response model from API
/// 
/// Maps API response to domain entity
@freezed
class UserResponse with _$UserResponse {
  const UserResponse._();

  const factory UserResponse({
    required String id,
    required String nickname,
    required String phone,
    String? avatar,
    String? email,
    @JsonKey(name: 'is_vip') @Default(false) bool isVip,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      nickname: nickname,
      phone: phone,
      avatar: avatar,
      email: email,
      isVip: isVip,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
    );
  }
}
