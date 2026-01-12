import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../entities/user_entity.dart';

/// User repository interface
/// 
/// Defines the contract for user-related data operations
/// Implementations should handle both remote API calls and local caching
abstract class UserRepository {
  /// Get user information from remote API
  /// 
  /// Returns Either<BaseException, UserEntity>
  /// - Left: Exception if operation fails
  /// - Right: UserEntity if operation succeeds
  Future<Either<BaseException, UserEntity>> getUserInfo(String userId);

  /// Update user information
  /// 
  /// Returns Either<BaseException, UserEntity>
  /// - Left: Exception if operation fails
  /// - Right: Updated UserEntity if operation succeeds
  Future<Either<BaseException, UserEntity>> updateUserInfo(UserEntity user);

  /// Logout user
  /// 
  /// Returns Either<BaseException, void>
  /// - Left: Exception if operation fails
  /// - Right: void if operation succeeds
  Future<Either<BaseException, void>> logout();

  /// Get cached user info from local storage
  /// 
  /// Returns null if no cached data exists
  Future<UserEntity?> getCachedUserInfo();

  /// Cache user info to local storage
  Future<void> cacheUserInfo(UserEntity user);

  /// Clear cached user info from local storage
  Future<void> clearCachedUserInfo();
}
