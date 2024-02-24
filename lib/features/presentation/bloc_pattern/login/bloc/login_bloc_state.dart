part of 'login_bloc_bloc.dart';

abstract class LoginState {}

abstract class LoginActionState extends LoginState {}
class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
 
class LoginNavigateToHome extends LoginActionState {}
class LoginNavigateToSiqgnup extends LoginActionState {}
