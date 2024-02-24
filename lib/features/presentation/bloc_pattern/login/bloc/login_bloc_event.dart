part of 'login_bloc_bloc.dart';

abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  late String firebaseUid;

  LoginButtonPressed({required this.email, required this.password});
}

class LoginNavigateToHome extends LoginEvent {
  
}


// class CheckDayExists extends LoginEvent {
//   final String firebaseUid;
//   final String date;

//   CheckDayExists({required this.firebaseUid, required this.date});
// }

// class CreateNewDay extends LoginEvent 
//   final String firebaseUid;
//   final String date;

//   CreateNewDay({required this.firebaseUid, required this.date});
// }
