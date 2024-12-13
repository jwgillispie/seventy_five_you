part of 'signup_bloc.dart';

abstract class SignupEvent {}

class SignupButtonPressedEvent extends SignupEvent {
  final String email;
  final String password;
  final String username;
  final String firstName;
  final String lastName;
  final List days;
  final List reminder;

  SignupButtonPressedEvent(
      {required this.username,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.days,
      required this.reminder});
}

class SignupNavigateToLoginEvent extends SignupEvent {}

class SignupNavigateToHomeEvent extends SignupEvent {}
