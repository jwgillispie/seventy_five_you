// lib/features/social/data/models/post_model.dart

import 'package:seventy_five_hard/features/social/domain/entities/post_model.dart';

class PostModel extends Post {
  PostModel({
    required String id,
    required String username,
    String profileImage = 'assets/images/zoro.jpg',  // Match the default from Post entity
    required String content,
    String postImage = 'assets/images/zoro.jpg',     // Match the default from Post entity
    required String timestamp,
    required String challenge,
    required List<String> tags,
    int likes = 0,
    bool isLiked = false,
    List<Comment> comments = const [],
    required int progress,
    required int streak,
  }) : super(
          id: id,
          username: username,
          profileImage: profileImage,
          content: content,
          postImage: postImage,
          timestamp: timestamp,
          challenge: challenge,
          tags: tags,
          likes: likes,
          isLiked: isLiked,
          comments: comments,
          progress: progress,
          streak: streak,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      profileImage: json['profile_image'] as String? ?? 'assets/images/zoro.jpg',
      content: json['content'] as String? ?? '',
      postImage: json['post_image'] as String? ?? 'assets/images/zoro.jpg',
      timestamp: json['timestamp'] as String? ?? '',
      challenge: json['challenge'] as String? ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      likes: json['likes'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      comments: (json['comments'] as List?)?.map((comment) => Comment(
            username: comment['username'] as String? ?? '',
            profileImage: comment['profile_image'] as String? ?? 'assets/images/zoro.jpg',
            content: comment['content'] as String? ?? '',
            timeAgo: comment['time_ago'] as String? ?? '',
            likes: comment['likes'] as int? ?? 0,
            isLiked: comment['is_liked'] as bool? ?? false,
          )).toList() ?? [],
      progress: json['progress'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profile_image': profileImage,
      'content': content,
      'post_image': postImage,
      'timestamp': timestamp,
      'challenge': challenge,
      'tags': tags,
      'likes': likes,
      'is_liked': isLiked,
      'comments': comments.map((comment) => {
        'username': comment.username,
        'profile_image': comment.profileImage,
        'content': comment.content,
        'time_ago': comment.timeAgo,
        'likes': comment.likes,
        'is_liked': comment.isLiked,
      }).toList(),
      'progress': progress,
      'streak': streak,
    };
  }
}