//lib/core/errors/failures.dart

abstract class Failure {
  final String message;
  
  const Failure(this.message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure({required String message, this.statusCode}) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure({required String message}) : super(message);
}