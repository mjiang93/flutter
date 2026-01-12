import 'package:isar/isar.dart';
import '../../../../domain/entities/user_entity.dart';

part 'user_isar_model.g.dart';

/// User Isar model for local storage
@collection
class UserIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String userId;

  late String nickname;
  late String phone;
  String? avatar;
  String? email;
  late bool isVip;
  DateTime? createdAt;

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: userId,
      nickname: nickname,
      phone: phone,
      avatar: avatar,
      email: email,
      isVip: isVip,
      createdAt: createdAt,
    );
  }

  /// Create from domain entity
  static UserIsarModel fromEntity(UserEntity entity) {
    return UserIsarModel()
      ..userId = entity.id
      ..nickname = entity.nickname
      ..phone = entity.phone
      ..avatar = entity.avatar
      ..email = entity.email
      ..isVip = entity.isVip
      ..createdAt = entity.createdAt;
  }
}
