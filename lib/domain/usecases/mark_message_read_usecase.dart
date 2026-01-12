import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../repositories/message_repository.dart';

/// Use case for marking a message as read
class MarkMessageReadUseCase {
  final MessageRepository _repository;

  MarkMessageReadUseCase(this._repository);

  /// Execute the use case
  /// 
  /// Returns Either<BaseException, void>
  /// - Left: Exception if operation fails
  /// - Right: void if operation succeeds
  Future<Either<BaseException, void>> call(String messageId) async {
    return await _repository.markAsRead(messageId);
  }
}
