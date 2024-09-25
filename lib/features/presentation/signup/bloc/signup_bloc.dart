import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:seventy_five_hard/features/presentation/signup/repos/signup_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupButtonPressedEvent>(signupButtonPressed);
    on<SignupNavigateToLoginEvent>(navigateToLogin);
    on<SignupNavigateToHomeEvent>(navigateToHome);
  }

  FutureOr<void> signupButtonPressed(
      SignupButtonPressedEvent event, Emitter<SignupState> emit) async {
    // emit(SignupLoading());
    User? user = await SignupRepository().signUp(event.email, event.password);
    if (user != null) {
      SignupRepository().createNewUser(user.uid, event.username, event.email,
          event.firstName, event.lastName, event.days);
      SignupRepository().createNewDay(user.uid);
      emit(SignupSuccess());
    } else {
      emit(SignupFailure("Signup Failed"));
    }
  }

  FutureOr<void> navigateToLogin(
    SignupNavigateToLoginEvent event, Emitter<SignupState> emit) {
    emit(SignupNavigateToLoginState());
  }

  FutureOr<void> navigateToHome(
      SignupNavigateToHomeEvent event, Emitter<SignupState> emit) {
    emit(SignupLoading());
  }
}
