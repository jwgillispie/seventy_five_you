import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';

// Post model (for demo purposes)
class Post {
  final String username;
  final String profileImage;
  final String content;
  final String? postImage;
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

class SocialPage extends StatelessWidget {
  final List<Post> posts = [
    Post(
      username: 'Jordan',
      profileImage: 'assets/images/food4.jpeg', // Add profile images to assets
      content: 'Just finished a killer workout! 💪 #75Hard',
      postImage: 'assets/images/food4.jpeg', // Post image example
      likes: 34,
      comments: ['Great job!', 'Keep pushing!'],
    ),
    Post(
      username: 'Mister Man',
      profileImage: 'assets/images/rock_lee.png',
      content: 'Staying hydrated!',
      postImage: 'assets/images/zoro.png',
      likes: 25,
      comments: ['Love it!', 'Water is key!'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Feed'),
        backgroundColor: theme.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor.withOpacity(0.2),
              theme.colorScheme.secondary.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return _buildPost(post, theme);
          },
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  Widget _buildPost(Post post, ThemeData theme) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
      shadowColor: theme.primaryColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header (Profile Image and Username)
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(post.profileImage),
                ),
                const SizedBox(width: 10),
                Text(
                  post.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Post Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                post.content,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.displayMedium?.color,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Post Image (optional)
            if (post.postImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.asset(post.postImage!, fit: BoxFit.cover),
              ),

            // Post Interaction (Likes and Comments)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up_alt_outlined),
                    color: theme.primaryColor,
                    onPressed: () {
                      // Handle like action
                    },
                  ),
                  Text(
                    '${post.likes} likes',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    color: theme.primaryColor,
                    onPressed: () {
                      // Handle comment action
                    },
                  ),
                  Text(
                    '${post.comments.length} comments',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Comments Section
            if (post.comments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: post.comments.map((comment) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        comment,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.displaySmall?.color,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
