import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../entities/message_entity.dart';
import '../repositories/message_repository.dart';

/// Use case for getting home page data with pagination
class GetHomeDataUseCase {
  final MessageRepository _repository;

  GetHomeDataUseCase(this._repository);

  /// Execute the use case
  /// 
  /// Returns Either<BaseException, List<MessageEntity>>
  /// - Left: Exception if operation fails
  /// - Right: List of messages if operation succeeds
  Future<Either<BaseException, List<MessageEntity>>> call({
    required int page,
    required int pageSize,
  }) async {
    return await _repository.getMessageList(
      page: page,
      pageSize: pageSize,
    );
  }
}
