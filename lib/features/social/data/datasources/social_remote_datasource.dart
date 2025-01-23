// lib/features/social/data/datasources/social_remote_datasource.dart

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seventy_five_hard/features/social/data/models/post_model.dart';
import 'package:seventy_five_hard/features/social/domain/entities/post_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';

abstract class SocialRemoteDataSource {
  Future<List<Post>> getPosts();
  Future<void> createPost(String content);
  Future<void> likePost(String postId);
  Future<void> commentOnPost(String postId, String comment);
}

class SocialRemoteDataSourceImpl implements SocialRemoteDataSource {
  final ApiClient _client;
  final FirebaseAuth _auth;

  SocialRemoteDataSourceImpl({
    required ApiClient client,
    required FirebaseAuth auth,
  })  : _client = client,
        _auth = auth;

  @override
  Future<List<Post>> getPosts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AuthException(message: 'Not authenticated');

      final response = await _client.get('/posts');
      final List<dynamic> postsJson = response['posts'];
      return postsJson.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> createPost(String content) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AuthException(message: 'Not authenticated');

      await _client.post(
        '/posts',
        body: {
          'userId': user.uid,
          'content': content,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> likePost(String postId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AuthException(message: 'Not authenticated');

      await _client.put(
        '/posts/$postId/like',
        body: {'userId': user.uid},
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> commentOnPost(String postId, String comment) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AuthException(message: 'Not authenticated');

      await _client.post(
        '/posts/$postId/comments',
        body: {
          'userId': user.uid,
          'content': comment,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}