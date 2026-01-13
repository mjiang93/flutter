import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:enterprise_flutter_app/core/errors/exceptions.dart';
import 'package:enterprise_flutter_app/domain/repositories/message_repository.dart';
import 'package:enterprise_flutter_app/domain/usecases/mark_message_read_usecase.dart';

// Mock MessageRepository
class MockMessageRepository extends Mock implements MessageRepository {}

void main() {
  group('MarkMessageReadUseCase', () {
    late MarkMessageReadUseCase markMessageReadUseCase;
    late MockMessageRepository mockMessageRepository;

    setUp(() {
      mockMessageRepository = MockMessageRepository();
      markMessageReadUseCase = MarkMessageReadUseCase(mockMessageRepository);
    });

    // Property 35: Message Mark as Read
    // For any message click, the message should be marked as read via API call
    // and the local cache should be updated.
    // **Validates: Requirements 20.3**
    group('Property 35: Message Mark as Read', () {
      test(
        'successful mark as read should call repository markAsRead',
        () async {
          // Arrange: Mock successful mark as read response
          const messageId = 'msg_123';
          when(mockMessageRepository.markAsRead(messageId))
              .thenAnswer((_) async => const Right(null));

          // Act: Call mark as read use case
          final result = await markMessageReadUseCase.call(messageId);

          // Assert: Verify mark as read succeeded
          expect(result, isA<Right>());

          // Assert: Verify repository markAsRead was called with correct messageId
          verify(mockMessageRepository.markAsRead(messageId)).called(1);
        },
      );

      test(
        'mark as read should return error if repository fails',
        () async {
          // Arrange: Mock failed mark as read response
          const messageId = 'msg_456';
          final exception = NetworkException('Network error', code: -1);
          when(mockMessageRepository.markAsRead(messageId))
              .thenAnswer((_) async => Left(exception));

          // Act: Call mark as read use case
          final result = await markMessageReadUseCase.call(messageId);

          // Assert: Verify mark as read failed
          expect(result, isA<Left>());
          result.fold(
            (error) => expect(error, isA<NetworkException>()),
            (success) => fail('Should have error'),
          );
        },
      );

      test(
        'mark as read should pass messageId to repository correctly',
        () async {
          // Arrange: Mock successful response
          const messageId = 'msg_789';
          when(mockMessageRepository.markAsRead(messageId))
              .thenAnswer((_) async => const Right(null));

          // Act: Call mark as read use case
          await markMessageReadUseCase.call(messageId);

          // Assert: Verify repository was called with exact messageId
          verify(mockMessageRepository.markAsRead(messageId)).called(1);
          verifyNoMoreInteractions(mockMessageRepository);
        },
      );

      test(
        'mark as read should handle business exception',
        () async {
          // Arrange
          const messageId = 'msg_test';
          final exception = BusinessException('Business error', code: 400);
          when(mockMessageRepository.markAsRead(messageId))
              .thenAnswer((_) async => Left(exception));

          // Act
          final result = await markMessageReadUseCase.call(messageId);

          // Assert: Verify error is returned
          expect(result, isA<Left>());
          result.fold(
            (error) => expect(error, isA<BusinessException>()),
            (success) => fail('Should have error'),
          );
        },
      );

      test(
        'mark as read should handle network exception',
        () async {
          // Arrange
          const messageId = 'msg_network';
          final exception = NetworkException('Network error', code: -1);
          when(mockMessageRepository.markAsRead(messageId))
              .thenAnswer((_) async => Left(exception));

          // Act
          final result = await markMessageReadUseCase.call(messageId);

          // Assert: Verify error is returned
          expect(result, isA<Left>());
          result.fold(
            (error) => expect(error, isA<NetworkException>()),
            (success) => fail('Should have error'),
          );
        },
      );

      test(
        'mark as read should handle system exception',
        () async {
          // Arrange
          const messageId = 'msg_system';
          final exception = SystemException('System error');
          when(mockMessageRepository.markAsRead(messageId))
              .thenAnswer((_) async => Left(exception));

          // Act
          final result = await markMessageReadUseCase.call(messageId);

          // Assert: Verify error is returned
          expect(result, isA<Left>());
          result.fold(
            (error) => expect(error, isA<SystemException>()),
            (success) => fail('Should have error'),
          );
        },
      );

      test(
        'mark as read should work with different messageIds',
        () async {
          // Test with multiple different messageIds to ensure
          // the use case correctly passes through the messageId parameter
          final messageIds = ['msg_1', 'msg_2', 'msg_3'];

          for (final messageId in messageIds) {
            // Arrange
            when(mockMessageRepository.markAsRead(messageId))
                .thenAnswer((_) async => const Right(null));

            // Act
            final result = await markMessageReadUseCase.call(messageId);

            // Assert: Verify success
            expect(result, isA<Right>());

            // Assert: Verify correct messageId was passed
            verify(mockMessageRepository.markAsRead(messageId)).called(1);

            // Reset mocks for next iteration
            reset(mockMessageRepository);
          }
        },
      );

      test(
        'mark as read should return Right on success',
        () async {
          // Arrange: Mock successful response
          const messageId = 'msg_success';
          when(mockMessageRepository.markAsRead(messageId))
              .thenAnswer((_) async => const Right(null));

          // Act: Call mark as read use case
          final result = await markMessageReadUseCase.call(messageId);

          // Assert: Verify result is Right
          expect(result, isA<Right>());
        },
      );

      test(
        'mark as read should return Left with exception on failure',
        () async {
          // Arrange: Mock failed response
          const messageId = 'msg_fail';
          final exception = BusinessException('Mark as read failed', code: 500);
          when(mockMessageRepository.markAsRead(messageId))
              .thenAnswer((_) async => Left(exception));

          // Act: Call mark as read use case
          final result = await markMessageReadUseCase.call(messageId);

          // Assert: Verify result is Left with exception
          expect(result, isA<Left>());
          result.fold(
            (error) => expect(error, isA<BusinessException>()),
            (success) => fail('Should have error'),
          );
        },
      );

      test(
        'mark as read should handle timeout exception',
        () async {
          // Arrange: Mock timeout exception
          const messageId = 'msg_timeout';
          final exception = ReceiveTimeoutException();
          when(mockMessageRepository.markAsRead(messageId))
              .thenAnswer((_) async => Left(exception));

          // Act: Call mark as read use case
          final result = await markMessageReadUseCase.call(messageId);

          // Assert: Verify timeout exception is returned
          expect(result, isA<Left>());
          result.fold(
            (error) => expect(error, isA<ReceiveTimeoutException>()),
            (success) => fail('Should have error'),
          );
        },
      );

      test(
        'mark as read should ensure repository method is called exactly once',
        () async {
          // Arrange: Mock successful response
          const messageId = 'msg_once';
          when(mockMessageRepository.markAsRead(messageId))
              .thenAnswer((_) async => const Right(null));

          // Act: Call mark as read use case
          await markMessageReadUseCase.call(messageId);

          // Assert: Verify repository was called exactly once
          verify(mockMessageRepository.markAsRead(messageId)).called(1);
        },
      );
    });
  });
}
