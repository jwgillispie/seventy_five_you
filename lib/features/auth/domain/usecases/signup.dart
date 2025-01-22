//lib/features/auth/domain/usecases/signup.dart

import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Signup {
  final AuthRepository repository;

  Signup(this.repository);

  Future<Either<Failure, User>> call(String email, String password, String username) async {
    return await repository.signUp(email, password, username);
  }
}