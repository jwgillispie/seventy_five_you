// Part file: user_event.dart

abstract class UserEvent {}

class FetchUserName extends UserEvent {
  final String userId;
  FetchUserName(this.userId);
}

class UpdateUserName extends UserEvent {
  final String userId;
  final String newName;
  UpdateUserName(this.userId, this.newName);
}