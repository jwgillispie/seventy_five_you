import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:seventy_five_hard/themes.dart';

class Post {
  final String username;
  final String? profileImage;
  final String content;
  final String? postImage;
  final String timeAgo;
  final String challenge;
  final List<String> tags;
  int likes;
  bool isLiked;
  final List<Comment> comments;

  Post({
    required this.username,
    this.profileImage,
    required this.content,
    this.postImage,
    required this.timeAgo,
    required this.challenge,
    required this.tags,
    this.likes = 0,
    this.isLiked = false,
    this.comments = const [],
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
    required this.profileImage,
    required this.content,
    required this.timeAgo,
    this.likes = 0,
    this.isLiked = false,
  });
}

class SocialPage extends StatefulWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> with SingleTickerProviderStateMixin {
  late TextEditingController _commentController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isComposing = false;
  Post? _selectedPost;

  final List<Post> posts = [
    Post(
      username: 'Jordan',
      profileImage: 'assets/images/food4.jpeg',
      content: 'Just crushed my second workout of the day! The mental strength you build during these sessions is incredible. Remember: it\'s not just about the physical transformation, it\'s about becoming mentally unshakeable. 💪 Who else is feeling unstoppable? #75Hard #MentalToughness',
      postImage: 'assets/images/food4.jpeg',
      timeAgo: '2h ago',
      challenge: 'Second Workout',
      tags: ['75Hard', 'MentalToughness', 'NoExcuses'],
      likes: 34,
      comments: [
        Comment(
          username: 'Sarah',
          profileImage: 'assets/images/profile1.jpg',
          content: 'You\'re crushing it! Keep that momentum going! 🔥',
          timeAgo: '1h ago',
          likes: 5,
        ),
        Comment(
          username: 'Mike',
          profileImage: 'assets/images/profile2.jpg',
          content: 'This is exactly the motivation I needed today!',
          timeAgo: '30m ago',
          likes: 3,
        ),
      ],
    ),
    Post(
      username: 'Mister Man',
      profileImage: 'assets/images/rock_lee.png',
      content: 'One gallon down! Staying hydrated is key to mental clarity and physical performance. It\'s amazing how such a simple habit can make such a big difference. Keep pushing, team! 💧',
      postImage: 'assets/images/zoro.png',
      timeAgo: '4h ago',
      challenge: 'Water Intake',
      tags: ['75Hard', 'StayHydrated', 'Discipline'],
      likes: 25,
      comments: [
        Comment(
          username: 'Lisa',
          profileImage: 'assets/images/profile3.jpg',
          content: 'Your consistency is inspiring! 🙌',
          timeAgo: '2h ago',
          likes: 4,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleLikePost(Post post) {
    setState(() {
      post.isLiked = !post.isLiked;
      if (post.isLiked) {
        post.likes++;
      } else {
        post.likes--;
      }
    });
  }

  void _showCommentSheet(Post post) {
    setState(() => _selectedPost = post);
    _animationController.forward();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCommentSheet(post),
    ).then((_) {
      setState(() => _selectedPost = null);
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildStoryBar(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildPost(posts[index]),
              childCount: posts.length,
            ),
          ),
        ],
      ),
      floatingActionButton: _buildPostFAB(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: SFColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: SFColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          '75 Hard Community',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Handle search
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Handle notifications
          },
        ),
      ],
    );
  }

  Widget _buildStoryBar() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddStoryButton();
          }
          final post = posts[index - 1];
          return _buildStoryAvatar(post);
        },
      ),
    );
  }

  Widget _buildAddStoryButton() {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: 30,
              color: SFColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add Story',
            style: TextStyle(
              color: SFColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryAvatar(Post post) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: SFColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage(post.profileImage!),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            post.username,
            style: TextStyle(
              color: SFColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPost(Post post) {
    final bool isSelected = _selectedPost == post;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(
        horizontal: isSelected ? 0 : 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSelected ? 0 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(post),
          if (post.postImage != null)
            _buildPostImage(post),
          _buildPostContent(post),
          _buildPostActions(post),
          _buildPostStats(post),
          _buildPostComments(post),
        ],
      ),
    );
  }

  Widget _buildPostHeader(Post post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(post.profileImage!),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.username,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      post.timeAgo,
                      style: TextStyle(
                        color: SFColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: SFColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        post.challenge,
                        style: TextStyle(
                          color: SFColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // Handle post options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage(Post post) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(post.postImage!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPostContent(Post post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.content,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: post.tags.map((tag) {
              return Text(
                '#$tag',
                style: TextStyle(
                  color: SFColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPostActions(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildActionButton(
            icon: post.isLiked 
              ? Icons.favorite 
              : Icons.favorite_border,
            color: post.isLiked ? Colors.red : null,
            onPressed: () => _handleLikePost(post),
          ),
          _buildActionButton(
            icon: Icons.chat_bubble_outline,
            onPressed: () => _showCommentSheet(post),
          ),
          _buildActionButton(
            icon: Icons.share_outlined,
            onPressed: () {
              // Handle share
            },
          ),
          const Spacer(),
          _buildActionButton(
            icon: Icons.bookmark_border,
            onPressed: () {
              // Handle bookmark
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: color ?? Colors.grey[700],
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildPostStats(Post post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            '${post.likes} likes',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${post.comments.length} comments',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostComments(Post post) {
    return Column(
      children: [
        if (post.comments.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: post.comments.take(2).map((comment) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage(comment.profileImage),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  comment.timeAgo,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(comment.content),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildActionButton(
                                  icon: comment.isLiked 
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_outline,
                                  color: comment.isLiked ? Colors.red : null,
                                  onPressed: () {
                                    setState(() {
                                      comment.isLiked = !comment.isLiked;
                                      if (comment.isLiked) {
                                        comment.likes++;
                                      } else {
                                        comment.likes--;
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  '${comment.likes}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Reply',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          if (post.comments.length > 2)
            TextButton(
              onPressed: () => _showCommentSheet(post),
              child: Text(
                'View all ${post.comments.length} comments',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
        _buildCommentInput(post),
      ],
    );
  }

  Widget _buildCommentInput(Post post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(posts[0].profileImage!), // Current user's avatar
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          AnimatedOpacity(
            opacity: _isComposing ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: SFColors.primary,
              ),
              onPressed: _isComposing
                  ? () {
                      setState(() {
                        post.comments.add(
                          Comment(
                            username: 'You',
                            profileImage: posts[0].profileImage!,
                            content: _commentController.text,
                            timeAgo: 'Just now',
                          ),
                        );
                        _commentController.clear();
                        _isComposing = false;
                      });
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSheet(Post post) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comments',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: post.comments.length,
              itemBuilder: (context, index) {
                final comment = post.comments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(comment.profileImage),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  comment.timeAgo,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(comment.content),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildActionButton(
                                  icon: comment.isLiked 
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_outline,
                                  color: comment.isLiked ? Colors.red : null,
                                  onPressed: () {
                                    setState(() {
                                      comment.isLiked = !comment.isLiked;
                                      if (comment.isLiked) {
                                        comment.likes++;
                                      } else {
                                        comment.likes--;
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  '${comment.likes}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Reply',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildCommentInput(post),
        ],
      ),
    );
  }

  Widget _buildPostFAB() {
    return FloatingActionButton(
      onPressed: () {
        // Handle new post creation
      },
      backgroundColor: SFColors.primary,
      child: const Icon(Icons.add),
    );
  }
}