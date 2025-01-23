// lib/features/social/presentation/bloc/social_event.dart
part of 'social_bloc.dart';

abstract class SocialEvent extends Equatable {
  const SocialEvent();

  @override
  List<Object> get props => [];
}

class LoadPosts extends SocialEvent {}

class CreatePost extends SocialEvent {
  final String content;

  const CreatePost(this.content);

  @override
  List<Object> get props => [content];
}

class LikePost extends SocialEvent {
  final String postId;

  const LikePost(this.postId);

  @override
  List<Object> get props => [postId];
}

class CommentOnPost extends SocialEvent {
  final String postId;
  final String comment;

  const CommentOnPost(this.postId, this.comment);

  @override
  List<Object> get props => [postId, comment];
}
