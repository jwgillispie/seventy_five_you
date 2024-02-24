import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../repos/login_repository.dart';
part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late LoginRepository loginRepository;

  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LoginNavigateToHome>(_onNavigateToHome);
  }
  
  EventHandler<LoginNavigateToHome, LoginState> get _onNavigateToHome => null;

  Future<void> _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await loginRepository.signIn(event.firebaseUid, event.email, event.password);
      emit(LoginSuccess());
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }
}
