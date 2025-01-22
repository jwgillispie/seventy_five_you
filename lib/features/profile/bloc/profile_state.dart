part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitialState extends ProfileState {}

// final class ProfileLoadingState extends ProfileState{}

// final class ProfileSuccessState extends ProfileState{}

// final class ProfileLoadFailureState extends ProfileState{
//   final String message;
//   ProfileLoadFailureState(this.message);
// }

// action states 

abstract class ProfileActionState extends ProfileState{}

final class ProfileToEditState extends ProfileActionState{}
// not necessary because editing function is built into the profile_page ui
final class ProfileNavigateToHomeState extends ProfileActionState{}
