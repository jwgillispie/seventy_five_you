part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class FetchUserName extends UserEvent {
  final String userId;
  FetchUserName(this.userId);
}
