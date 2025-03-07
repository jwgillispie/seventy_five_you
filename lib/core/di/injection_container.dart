// lib/core/di/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/services/firebase_auth_service.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/signup.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  print("DI: Initializing dependencies");
  
  // Features - Auth
  _initAuth();
  
  // Core
  _initCore();

  // External
  _initExternal();
  
  print("DI: Dependencies initialized successfully");
}

void _initAuth() {
  print("DI: Initializing Auth dependencies");
  
  // Bloc
  sl.registerFactory(
    () {
      print("DI: Creating AuthBloc");
      return AuthBloc(
        login: sl(),
        signup: sl(),
      );
    },
  );

  // Use cases
  sl.registerLazySingleton(() {
    print("DI: Registering Login use case");
    return Login(sl());
  });
  sl.registerLazySingleton(() {
    print("DI: Registering Signup use case");
    return Signup(sl());
  });

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () {
      print("DI: Registering AuthRepository");
      return AuthRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      );
    },
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () {
      print("DI: Registering AuthRemoteDataSource");
      return AuthRemoteDataSourceImpl(
        firebaseAuth: sl(),
        apiClient: sl(),
      );
    },
  );

  // Services
  sl.registerLazySingleton(
    () {
      print("DI: Registering FirebaseAuthService");
      return FirebaseAuthService(auth: sl());
    },
  );
}

void _initCore() {
  print("DI: Initializing Core dependencies");
  
  sl.registerLazySingleton<NetworkInfo>(
    () {
      print("DI: Registering NetworkInfo");
      return NetworkInfoImpl(sl());
    },
  );
  
  sl.registerLazySingleton(
    () {
      print("DI: Registering ApiClient");
      return ApiClient(client: sl());
    },
  );
}

void _initExternal() {
  print("DI: Initializing External dependencies");
  
  sl.registerLazySingleton(
    () {
      print("DI: Registering FirebaseAuth.instance");
      return FirebaseAuth.instance;
    },
  );
  
  sl.registerLazySingleton(
    () {
      print("DI: Registering InternetConnectionChecker");
      return InternetConnectionChecker();
    },
  );
  
  sl.registerLazySingleton(
    () {
      print("DI: Registering http.Client");
      return http.Client();
    },
  );
}