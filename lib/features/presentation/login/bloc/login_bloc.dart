import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../repos/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginButtonPressedEvent> (loginButtonPressed);
    on<LoginNavigateToSignupEvent> (navigateToSignup);
    on<LoginNavigateToHomeEvent> (navigateToHome);
  }

  FutureOr<void> loginButtonPressed(LoginButtonPressedEvent event, Emitter<LoginState> emit) async{
    emit(LoginLoadingState());
    User? user = await LoginRepository().signIn(event.email, event.password);
    if(user != null){
      emit(LoginSuccessState());
    }
    else{
      emit(LoginFailureState("Login Failed"));
    }
  }

  FutureOr<void> navigateToSignup(LoginNavigateToSignupEvent event, Emitter<LoginState> emit) {
    emit(LoginNavigateToSignupState());
  }

  FutureOr<void> navigateToHome(LoginNavigateToHomeEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    bool dateExists = await LoginRepository().checkIfDayExists(event.firebaseUid);
    if(dateExists){
      emit(LoginNavigateToHomeState());
    }
    else{
      await LoginRepository().createNewDay(event.firebaseUid);
      emit(LoginNavigateToHomeState());
    }


  }
}
