// lib/features/social/domain/entities/post_model.dart
class Post {
  final String id;
  final String username;
  final String profileImage;
  final String content;
  final String? postImage;
  final String timestamp;
  final String challenge;
  final List<String> tags;
  final int likes;
  final bool isLiked;
  final List<Comment> comments;
  final int progress;
  final int streak;

  Post({
    required this.id,
    required this.username,
    this.profileImage = 'assets/images/zoro.jpg',
    required this.content,
    this.postImage = 'assets/images/zoro.jpg',
    required this.timestamp,
    required this.challenge,
    required this.tags,
    this.likes = 0,
    this.isLiked = false,
    this.comments = const [],
    required this.progress,
    required this.streak,
  });
}

class Comment {
  final String username;
  final String profileImage;
  final String content;
  final String timeAgo;
  int likes;
  bool isLiked;

  Comment({
    required this.username,
    this.profileImage = 'assets/images/zoro.jpg',
    required this.content,
    required this.timeAgo,
    this.likes = 0,
    this.isLiked = false,
  });
}

// Sample data
final List<Post> samplePosts = [
  Post(
    id: '1',
    username: 'John Doe',
    content: 'Just completed my morning workout! Feeling energized 💪',
    timestamp: '2h ago',
    challenge: 'Workout 1',
    tags: ['75Hard', 'Fitness', 'Progress'],
    progress: 85,
    streak: 45,
  ),
  Post(
    id: '2',
    username: 'Jane Smith',
    content: 'Water intake goal achieved! Staying hydrated is key 💧',
    timestamp: '4h ago',
    challenge: 'Water',
    tags: ['75Hard', 'Hydration'],
    progress: 100,
    streak: 32,
  ),
];