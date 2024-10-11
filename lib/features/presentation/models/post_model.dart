class Post {
  final String username;
  final String profileImage;
  final String content;
  final String? postImage; // Optional post image
  final int likes;
  final List<String> comments;

  Post({
    required this.username,
    required this.profileImage,
    required this.content,
    this.postImage,
    this.likes = 0,
    this.comments = const [],
  });
}
