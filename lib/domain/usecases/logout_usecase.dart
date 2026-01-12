import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../repositories/user_repository.dart';

/// Use case for logging out user
/// 
/// Handles both remote logout and local data cleanup
class LogoutUseCase {
  final UserRepository _repository;

  LogoutUseCase(this._repository);

  /// Execute the use case
  /// 
  /// Returns Either<BaseException, void>
  /// - Left: Exception if remote logout fails
  /// - Right: void if operation succeeds
  /// 
  /// Note: Local cache is cleared regardless of remote result
  Future<Either<BaseException, void>> call() async {
    // Call remote logout API
    final result = await _repository.logout();

    // Clear local cache regardless of remote result
    // This ensures user data is cleaned up even if network fails
    await _repository.clearCachedUserInfo();

    return result;
  }
}
