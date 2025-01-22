//lib/features/auth/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn(String email, String password);
  Future<Either<Failure, User>> signUp(String email, String password, String username);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, void>> updateUserProfile(User user);
}