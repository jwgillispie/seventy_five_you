part of 'sign_up_bloc_bloc.dart';
abstract class SignUpEvent {}

class SignUpButtonPressed extends SignUpEvent {
  final String email;
  final String password;
  final String username;
  final String firstName;
  final String lastName;

  SignUpButtonPressed({required this.email, required this.password, required this.username, required this.firstName, required this.lastName});
}

