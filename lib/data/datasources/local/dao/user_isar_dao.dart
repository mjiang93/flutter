import 'package:isar/isar.dart';
import '../../../../domain/entities/user_entity.dart';
import '../models/user_isar_model.dart';

/// User Isar DAO
/// 
/// Handles user data operations in local Isar database
class UserIsarDao {
  final Isar _isar;

  UserIsarDao(this._isar);

  /// Get user info by user ID
  Future<UserEntity?> getUserInfo(String userId) async {
    final model = await _isar.userIsarModels
        .filter()
        .userIdEqualTo(userId)
        .findFirst();
    return model?.toEntity();
  }

  /// Save user info
  Future<void> saveUserInfo(UserEntity user) async {
    await _isar.writeTxn(() async {
      await _isar.userIsarModels.put(UserIsarModel.fromEntity(user));
    });
  }

  /// Delete user info by user ID
  Future<void> deleteUserInfo(String userId) async {
    await _isar.writeTxn(() async {
      await _isar.userIsarModels
          .filter()
          .userIdEqualTo(userId)
          .deleteAll();
    });
  }

  /// Clear all user data
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.userIsarModels.clear();
    });
  }
}
