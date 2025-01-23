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
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signIn(email, password);
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(
    String email,
    String password,
    String username,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signUp(email, password, username);
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user != null) {
        return Right(user);
      } else {
        return Left(AuthFailure(message: 'No user logged in'));
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(User user) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateUserProfile(user as UserModel);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}