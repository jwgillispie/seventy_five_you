//lib/core/di/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/signup.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  _initAuth();
  
  // Core
  _initCore();

  // External
  _initExternal();
}

void _initAuth() {
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      signup: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Signup(sl()));
  // Add to _initAuth() in injection_container.dart
sl.registerLazySingleton<AuthPersistenceService>(
  () => AuthPersistenceServiceImpl(sl()),
);

// Add to _initExternal() in injection_container.dart
final sharedPreferences = await SharedPreferences.getInstance();
sl.registerLazySingleton(() => sharedPreferences);

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      apiClient: sl(),
    ),
  );
}

void _initCore() {
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );
  
  sl.registerLazySingleton(
    () => ApiClient(),
  );
}

void _initExternal() {
  sl.registerLazySingleton(
    () => FirebaseAuth.instance,
  );
  // Add to _initAuth() in injection_container.dart
sl.registerLazySingleton<AuthPersistenceService>(
  () => AuthPersistenceServiceImpl(sl()),
);

// Add to _initExternal() in injection_container.dart
final sharedPreferences = await SharedPreferences.getInstance();
sl.registerLazySingleton(() => sharedPreferences);
  
  sl.registerLazySingleton(
    () => InternetConnectionChecker(),
  );
}