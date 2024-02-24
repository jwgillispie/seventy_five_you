import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:seventy_five_hard/features/presentation/bloc_pattern/users/repos/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  UserBloc() : super(UserInitial()) {
    on<FetchUserName>(_onFetchUserName);
  }
  Future<void> _onFetchUserName(FetchUserName event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final userRepository = UserRepository();
      final userName = await userRepository.fetchUserName(event.userId);
      emit(UserLoaded(userName));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}