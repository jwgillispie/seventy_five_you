
// lib/features/social/presentation/bloc/social_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seventy_five_hard/features/social/domain/entities/post_model.dart';
import '../../domain/repositories/social_repository.dart';

part 'social_event.dart';
part 'social_state.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  final SocialRepository repository;

  SocialBloc({required this.repository}) : super(SocialInitial()) {
    on<LoadPosts>(_onLoadPosts);
    on<CreatePost>(_onCreatePost);
    on<LikePost>(_onLikePost);
    on<CommentOnPost>(_onCommentOnPost);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<SocialState> emit) async {
    try {
      emit(SocialLoading());
      final result = await repository.getPosts();
      result.fold(
        (failure) => emit(SocialError(failure.message)),
        (posts) => emit(SocialLoaded(posts)),
      );
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<SocialState> emit) async {
    try {
      emit(SocialLoading());
      final createResult = await repository.createPost(event.content);
      await createResult.fold(
        (failure) async => emit(SocialError(failure.message)),
        (_) async {
          final postsResult = await repository.getPosts();
          postsResult.fold(
            (failure) => emit(SocialError(failure.message)),
            (posts) => emit(SocialLoaded(posts)),
          );
        },
      );
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onLikePost(LikePost event, Emitter<SocialState> emit) async {
    try {
      final likeResult = await repository.likePost(event.postId);
      await likeResult.fold(
        (failure) async => emit(SocialError(failure.message)),
        (_) async {
          final postsResult = await repository.getPosts();
          postsResult.fold(
            (failure) => emit(SocialError(failure.message)),
            (posts) => emit(SocialLoaded(posts)),
          );
        },
      );
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onCommentOnPost(CommentOnPost event, Emitter<SocialState> emit) async {
    try {
      final commentResult = await repository.commentOnPost(event.postId, event.comment);
      await commentResult.fold(
        (failure) async => emit(SocialError(failure.message)),
        (_) async {
          final postsResult = await repository.getPosts();
          postsResult.fold(
            (failure) => emit(SocialError(failure.message)),
            (posts) => emit(SocialLoaded(posts)),
          );
        },
      );
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }
}