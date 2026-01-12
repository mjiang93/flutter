import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../repositories/message_repository.dart';

/// Use case for getting unread message count
class GetUnreadMessageUseCase {
  final MessageRepository _repository;

  GetUnreadMessageUseCase(this._repository);

  /// Execute the use case
  /// 
  /// Returns Either<BaseException, int>
  /// - Left: Exception if operation fails
  /// - Right: Unread message count if operation succeeds
  Future<Either<BaseException, int>> call() async {
    return await _repository.getUnreadCount();
  }
}
