import 'package:get_it/get_it.dart';
import '../data/datasources/local/dao/cached_request_isar_dao.dart';
import '../data/datasources/local/dao/message_isar_dao.dart';
import '../data/datasources/local/dao/user_isar_dao.dart';
import '../data/datasources/local/isar_manager.dart';
import '../data/datasources/remote/api/message_api_service.dart';
import '../data/datasources/remote/api/user_api_service.dart';
import '../data/datasources/remote/api_client.dart';
import '../data/datasources/remote/services/request_cache_service.dart';
import '../data/repositories/message_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/message_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/usecases/get_home_data_usecase.dart';
import '../domain/usecases/get_unread_message_usecase.dart';
import '../domain/usecases/get_user_info_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/mark_message_read_usecase.dart';

/// Dependency injection container
final getIt = GetIt.instance;

/// Setup dependency injection
/// 
/// Registers all dependencies in the correct order:
/// 1. Core services (API client, Isar)
/// 2. DAOs
/// 3. API services
/// 4. Repositories
/// 5. Use cases
Future<void> setupLocator() async {
  // Core services
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Register Isar instance
  final isar = await IsarManager.instance;
  getIt.registerSingleton(isar);

  // DAOs
  getIt.registerLazySingleton<UserIsarDao>(
    () => UserIsarDao(getIt()),
  );
  getIt.registerLazySingleton<MessageIsarDao>(
    () => MessageIsarDao(getIt()),
  );
  getIt.registerLazySingleton<CachedRequestIsarDao>(
    () => CachedRequestIsarDao(getIt()),
  );

  // API Services
  getIt.registerLazySingleton<UserApiService>(
    () => UserApiService(getIt<ApiClient>().dio),
  );
  getIt.registerLazySingleton<MessageApiService>(
    () => MessageApiService(getIt<ApiClient>().dio),
  );

  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      getIt<UserApiService>(),
      getIt<UserIsarDao>(),
    ),
  );
  getIt.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(
      getIt<MessageApiService>(),
      getIt<MessageIsarDao>(),
    ),
  );

  // Services
  getIt.registerLazySingleton<RequestCacheService>(
    () => RequestCacheService(
      getIt<CachedRequestIsarDao>(),
      getIt<ApiClient>().dio,
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<GetUserInfoUseCase>(
    () => GetUserInfoUseCase(getIt<UserRepository>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<UserRepository>()),
  );
  getIt.registerLazySingleton<GetUnreadMessageUseCase>(
    () => GetUnreadMessageUseCase(getIt<MessageRepository>()),
  );
  getIt.registerLazySingleton<MarkMessageReadUseCase>(
    () => MarkMessageReadUseCase(getIt<MessageRepository>()),
  );
  getIt.registerLazySingleton<GetHomeDataUseCase>(
    () => GetHomeDataUseCase(getIt<MessageRepository>()),
  );
}
