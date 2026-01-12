import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case for getting user information
/// 
/// Implements cache-first strategy:
/// 1. Try to get from local cache first
/// 2. If cache miss, fetch from remote API
/// 3. Cache the result if successful
class GetUserInfoUseCase {
  final UserRepository _repository;

  GetUserInfoUseCase(this._repository);

  /// Execute the use case
  /// 
  /// Returns Either<BaseException, UserEntity>
  /// - Left: Exception if operation fails
  /// - Right: UserEntity if operation succeeds
  Future<Either<BaseException, UserEntity>> call(String userId) async {
    // Try to get from cache first
    final cachedUser = await _repository.getCachedUserInfo();
    if (cachedUser != null) {
      return Right(cachedUser);
    }

    // Fetch from remote
    final result = await _repository.getUserInfo(userId);

    // Cache if successful
    result.fold(
      (error) => null,
      (user) => _repository.cacheUserInfo(user),
    );

    return result;
  }
}
