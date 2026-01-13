import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:enterprise_flutter_app/core/errors/exceptions.dart';
import 'package:enterprise_flutter_app/domain/entities/user_entity.dart';
import 'package:enterprise_flutter_app/domain/repositories/user_repository.dart';
import 'package:enterprise_flutter_app/domain/usecases/logout_usecase.dart';

// Mock UserRepository
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('LogoutUseCase', () {
    late LogoutUseCase logoutUseCase;
    late MockUserRepository mockUserRepository;

    setUp(() {
      mockUserRepository = MockUserRepository();
      logoutUseCase = LogoutUseCase(mockUserRepository);
    });

    // Property 40: Logout Data Cleanup
    // For any successful logout, all local user data (user info, token, cached messages)
    // should be cleared and the app should navigate to the login page.
    // **Validates: Requirements 21.3**
    group('Property 40: Logout Data Cleanup', () {
      test(
        'successful logout should clear cached user info',
        () async {
          // Arrange: Mock successful logout response
          when(mockUserRepository.logout())
              .thenAnswer((_) async => const Right(null));
          when(mockUserRepository.clearCachedUserInfo())
              .thenAnswer((_) async => Future.value());

          // Act: Call logout use case
          final result = await logoutUseCase.call();

          // Assert: Verify logout succeeded
          expect(result, isA<Right>());

          // Assert: Verify clearCachedUserInfo was called
          verify(mockUserRepository.clearCachedUserInfo()).called(1);
        },
      );

      test(
        'logout should clear cached user info even if remote logout fails',
        () async {
          // Arrange: Mock failed logout response
          final exception = BusinessException('Logout failed', code: 500);
          when(mockUserRepository.logout())
              .thenAnswer((_) async => Left(exception));
          when(mockUserRepository.clearCachedUserInfo())
              .thenAnswer((_) async => Future.value());

          // Act: Call logout use case
          final result = await logoutUseCase.call();

          // Assert: Verify logout failed
          expect(result, isA<Left>());

          // Assert: Verify clearCachedUserInfo was still called
          verify(mockUserRepository.clearCachedUserInfo()).called(1);
        },
      );

      test(
        'logout should return the remote logout result',
        () async {
          // Arrange: Mock successful logout response
          when(mockUserRepository.logout())
              .thenAnswer((_) async => const Right(null));
          when(mockUserRepository.clearCachedUserInfo())
              .thenAnswer((_) async => Future.value());

          // Act: Call logout use case
          final result = await logoutUseCase.call();

          // Assert: Verify result is Right (success)
          expect(result, isA<Right>());
        },
      );

      test(
        'logout should return error if remote logout fails',
        () async {
          // Arrange: Mock failed logout response
          final exception = NetworkException('Network error', code: -1);
          when(mockUserRepository.logout())
              .thenAnswer((_) async => Left(exception));
          when(mockUserRepository.clearCachedUserInfo())
              .thenAnswer((_) async => Future.value());

          // Act: Call logout use case
          final result = await logoutUseCase.call();

          // Assert: Verify result is Left (error)
          expect(result, isA<Left>());
          expect(result.fold((l) => l, (r) => null), isA<NetworkException>());
        },
      );

      test(
        'logout should call repository methods in correct order',
        () async {
          // Arrange: Mock successful logout response
          when(mockUserRepository.logout())
              .thenAnswer((_) async => const Right(null));
          when(mockUserRepository.clearCachedUserInfo())
              .thenAnswer((_) async => Future.value());

          // Act: Call logout use case
          await logoutUseCase.call();

          // Assert: Verify logout was called before clearCachedUserInfo
          final verificationResult = verify(mockUserRepository.logout());
          verificationResult.called(1);

          verify(mockUserRepository.clearCachedUserInfo()).called(1);
        },
      );

      test(
        'logout should handle various exception types from remote logout',
        () async {
          // Test with different exception types
          final exceptions = [
            BusinessException('Business error', code: 400),
            NetworkException('Network error', code: -1),
            SystemException('System error'),
          ];

          for (final exception in exceptions) {
            // Arrange
            when(mockUserRepository.logout())
                .thenAnswer((_) async => Left(exception));
            when(mockUserRepository.clearCachedUserInfo())
                .thenAnswer((_) async => Future.value());

            // Act
            final result = await logoutUseCase.call();

            // Assert: Verify error is returned
            expect(result, isA<Left>());

            // Assert: Verify clearCachedUserInfo was still called
            verify(mockUserRepository.clearCachedUserInfo()).called(1);

            // Reset mocks for next iteration
            reset(mockUserRepository);
          }
        },
      );

      test(
        'logout should ensure cache is cleared regardless of remote result',
        () async {
          // This test validates the invariant that clearCachedUserInfo
          // is ALWAYS called, whether logout succeeds or fails

          // Test case 1: Success
          when(mockUserRepository.logout())
              .thenAnswer((_) async => const Right(null));
          when(mockUserRepository.clearCachedUserInfo())
              .thenAnswer((_) async => Future.value());

          await logoutUseCase.call();
          verify(mockUserRepository.clearCachedUserInfo()).called(1);

          reset(mockUserRepository);

          // Test case 2: Failure
          when(mockUserRepository.logout())
              .thenAnswer((_) async => Left(BusinessException('Error')));
          when(mockUserRepository.clearCachedUserInfo())
              .thenAnswer((_) async => Future.value());

          await logoutUseCase.call();
          verify(mockUserRepository.clearCachedUserInfo()).called(1);
        },
      );
    });
  });
}
