import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:seventy_five_hard/features/presentation/bloc_pattern/sign_up/repos/sign_up_repository.dart';
 // Import your SignUpRepository

part 'sign_up_bloc_event.dart';
part 'sign_up_bloc_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpRepository signUpRepository;

  SignUpBloc({required this.signUpRepository}) : super(SignUpInitial()) {
    on<SignUpButtonPressed>(_onSignUpSubmitted);
  }

  void _onSignUpSubmitted(SignUpButtonPressed event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      User? user = await signUpRepository.signUpWithEmailAndPassword(event.email, event.password);
      if (user != null) {
        // Assuming you have a method to send user data to backend
        bool userDataSent = await signUpRepository.sendUserDataToBackend(
            user.uid, event.username, event.email, event.firstName, event.lastName);

        if (userDataSent) {
          // Assuming you have a method to create a new day object in backend
          bool dayObjectSent = await signUpRepository.createNewDay(user.uid);

          if (dayObjectSent) {
            emit(SignUpSuccess());
          } else {
            emit(SignUpFailure(error: "Failed to create day object"));
          }
        } else {
          emit(SignUpFailure(error: "Failed to send user data"));
        }
      } else {
        emit(SignUpFailure(error: "Sign Up Failed"));
      }
    } catch (e) {
      emit(SignUpFailure(error: e.toString()));
    }
  }
}
