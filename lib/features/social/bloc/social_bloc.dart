import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'social_event.dart';
part 'social_state.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  SocialBloc() : super(SocialInitial()) {
    on<SocialEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
