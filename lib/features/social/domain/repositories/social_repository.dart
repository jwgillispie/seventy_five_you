// lib/features/social/domain/repositories/social_repository.dart

import 'package:dartz/dartz.dart';
import 'package:seventy_five_hard/features/social/domain/entities/post_model.dart';
import '../../../../core/errors/failures.dart';

abstract class SocialRepository {
  Future<Either<Failure, List<Post>>> getPosts();
  Future<Either<Failure, void>> createPost(String content);
  Future<Either<Failure, void>> likePost(String postId);
  Future<Either<Failure, void>> commentOnPost(String postId, String comment);
}