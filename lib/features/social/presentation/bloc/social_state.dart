// lib/features/social/presentation/bloc/social_state.dart
part of 'social_bloc.dart';

abstract class SocialState extends Equatable {
  const SocialState();
  
  @override
  List<Object> get props => [];
}

class SocialInitial extends SocialState {}

class SocialLoading extends SocialState {}

class SocialLoaded extends SocialState {
  final List<Post> posts;

  const SocialLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class SocialError extends SocialState {
  final String message;

  const SocialError(this.message);

  @override
  List<Object> get props => [message];
}
