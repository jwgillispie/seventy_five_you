import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../repos/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
    ProfileBloc() : super(ProfileInitialState()) {
      on<ProfileNavigateToHomeEvent> (navigateToHome);
      on<ProfileToEditEvent> (profileToEdit);
    }  

    FutureOr<void> profileToEdit(ProfileToEditEvent event, Emitter<ProfileState> emit) async {
      emit(ProfileToEditState());
    }
    
    FutureOr<void> navigateToHome(ProfileNavigateToHomeEvent event, Emitter<ProfileState> emit) async {
      emit(ProfileNavigateToHomeState());
    }

}    
