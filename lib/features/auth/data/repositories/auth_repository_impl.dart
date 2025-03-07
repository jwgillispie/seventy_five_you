//lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:seventy_five_hard/features/auth/data/models/user_model.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    print("AuthRepository: Attempting to sign in with email: $email");
    if (await networkInfo.isConnected) {
      try {
        print("AuthRepository: Network is connected, calling remote data source");
        final user = await remoteDataSource.signIn(email, password);
        print("AuthRepository: Sign in successful for user: ${user.displayName}");
        return Right(user);
      } on AuthException catch (e) {
        print("AuthRepository: AuthException caught: ${e.message}");
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        print("AuthRepository: ServerException caught: ${e.message} (${e.statusCode})");
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      } catch (e) {
        print("AuthRepository: Unexpected error caught: $e");
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      print("AuthRepository: No internet connection");
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(
    String email,
    String password,
    String username,
  ) async {
    print("AuthRepository: Attempting to sign up with email: $email, username: $username");
    if (await networkInfo.isConnected) {
      try {
        print("AuthRepository: Network is connected, calling remote data source");
        final user = await remoteDataSource.signUp(email, password, username);
        print("AuthRepository: Sign up successful for user: ${user.displayName}");
        return Right(user);
      } on AuthException catch (e) {
        print("AuthRepository: AuthException caught: ${e.message}");
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        print("AuthRepository: ServerException caught: ${e.message} (${e.statusCode})");
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      } catch (e) {
        print("AuthRepository: Unexpected error caught: $e");
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      print("AuthRepository: No internet connection");
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    print("AuthRepository: Attempting to sign out");
    try {
      await remoteDataSource.signOut();
      print("AuthRepository: Sign out successful");
      return const Right(null);
    } on AuthException catch (e) {
      print("AuthRepository: AuthException caught: ${e.message}");
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      print("AuthRepository: Unexpected error caught: $e");
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    print("AuthRepository: Getting current user");
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user != null) {
        print("AuthRepository: Current user found: ${user.displayName}");
        return Right(user);
      } else {
        print("AuthRepository: No current user found");
        return const Left(AuthFailure(message: 'No user logged in'));
      }
    } on AuthException catch (e) {
      print("AuthRepository: AuthException caught: ${e.message}");
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      print("AuthRepository: Unexpected error caught: $e");
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(User user) async {
    print("AuthRepository: Updating user profile for: ${user.displayName}");
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateUserProfile(user as UserModel);
        print("AuthRepository: Profile update successful");
        return const Right(null);
      } on ServerException catch (e) {
        print("AuthRepository: ServerException caught: ${e.message} (${e.statusCode})");
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      } catch (e) {
        print("AuthRepository: Unexpected error caught: $e");
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      print("AuthRepository: No internet connection");
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}