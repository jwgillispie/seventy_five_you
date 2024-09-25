part of 'signup_bloc.dart';

abstract class SignupState {}

final class SignupInitial extends SignupState {}

final class SignupLoading extends SignupState{}

final class SignupSuccess extends SignupState{}

final class SignupFailure extends SignupState{
  final String message;
  SignupFailure(this.message);
}

// action states
abstract class SignupActionState extends SignupState{}

final class SignupNavigateToLoginState extends SignupActionState{}



