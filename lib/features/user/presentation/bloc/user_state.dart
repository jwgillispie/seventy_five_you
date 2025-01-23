
// Part file: user_state.dart

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final String username;
  UserLoaded(this.username);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}