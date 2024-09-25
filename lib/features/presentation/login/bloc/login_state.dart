part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitialState extends LoginState {}

final class LoginLoadingState extends LoginState{}

final class LoginSuccessState extends LoginState{}

final class LoginFailureState extends LoginState{
  final String message;
  LoginFailureState(this.message);
}

// action states 

abstract class LoginActionState extends LoginState{}

final class LoginNavigateToSignupState extends LoginActionState{}
final class LoginNavigateToHomeState extends LoginActionState{}
