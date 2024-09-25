part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginButtonPressedEvent extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressedEvent({required this.email, required this.password});
}

// class SignupButtonPressedEvent extends LoginEvent{}
class LoginNavigateToHomeEvent extends LoginEvent {
  final String firebaseUid;

  LoginNavigateToHomeEvent({required this.firebaseUid});

}

class LoginNavigateToSignupEvent extends LoginEvent {}
