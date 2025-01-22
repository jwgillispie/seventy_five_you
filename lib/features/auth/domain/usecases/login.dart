//lib/features/auth/domain/usecases/login.dart

import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Either<Failure, User>> call(String email, String password) async {
    return await repository.signIn(email, password);
  }
}