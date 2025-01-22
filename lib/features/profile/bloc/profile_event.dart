part of 'profile_bloc.dart';

abstract class ProfileEvent {}

// need two events: one for returning to Home screen and one for editing profile
class ProfileNavigateToHomeEvent extends ProfileEvent {
  // final String firebaseUid;
  // LoginNavigateToHomeEvent({required this.firebaseUid});
  // ^ I don't think I need this
}

class ProfileToEditEvent extends ProfileEvent {
  // necessary to communicate with repo to update any changes
  // but this is probably not necessary here
  // I think this event should only need to change the ui to a editing profile page
}
