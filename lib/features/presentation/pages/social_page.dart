import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/features/presentation/models/post_model.dart';
import 'package:seventy_five_hard/themes.dart';

class Challenge {
  final int id;
  final IconData icon;
  final String name;
  final int count;

  Challenge({
    required this.id,
    required this.icon,
    required this.name,
    required this.count,
  });
}

class EnhancedSocialPage extends StatefulWidget {
  const EnhancedSocialPage({Key? key}) : super(key: key);

  @override
  _EnhancedSocialPageState createState() => _EnhancedSocialPageState();
}

class _EnhancedSocialPageState extends State<EnhancedSocialPage>
    with SingleTickerProviderStateMixin {
  int? selectedChallenge;
  int? expandedPost;
  final List<Post> posts = samplePosts; // Add this line

  late AnimationController _animationController;
  // get user from

  final List<Challenge> challenges = [
    Challenge(id: 1, icon: Icons.directions_run, name: 'Workout 1', count: 45),
    Challenge(id: 2, icon: Icons.fitness_center, name: 'Workout 2', count: 38),
    Challenge(id: 3, icon: Icons.water_drop, name: 'Water', count: 52),
    Challenge(id: 4, icon: Icons.menu_book, name: 'Reading', count: 29),
    Challenge(id: 5, icon: Icons.camera_alt, name: 'Progress', count: 33),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [SFColors.neutral, SFColors.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Text(
            "75 Hard Community",
            style: GoogleFonts.orbitron(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: SFColors.surface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Share Your Journey",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: SFColors.surface.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeHub() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SFColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: SFColors.neutral.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Challenge Hub',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: SFColors.textPrimary,
                ),
              ),
              Icon(Icons.military_tech, color: SFColors.tertiary),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: challenges.map((challenge) {
                final isSelected = selectedChallenge == challenge.id;
                return GestureDetector(
                  onTap: () => setState(() => selectedChallenge = challenge.id),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [SFColors.neutral, SFColors.tertiary])
                          : null,
                      color: isSelected ? null : SFColors.background,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? SFColors.neutral.withOpacity(0.2)
                              : SFColors.neutral.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          challenge.icon,
                          color: isSelected
                              ? SFColors.surface
                              : SFColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              challenge.name,
                              style: TextStyle(
                                color: isSelected
                                    ? SFColors.surface
                                    : SFColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${challenge.count} posts',
                              style: TextStyle(
                                color: isSelected
                                    ? SFColors.surface.withOpacity(0.8)
                                    : SFColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPost(Post post) {
    final isExpanded = expandedPost == post.id;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: SFColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: SFColors.neutral.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage("./assets/images/zoro.jpg"),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "JOZO",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: SFColors.textPrimary,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 14,
                                color: SFColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Day 69',
                                style: TextStyle(
                                  color: SFColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      post.timestamp,
                      style: TextStyle(
                        color: SFColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (post.postImage != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.asset(
                          post.postImage!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  SFColors.neutral.withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: post.progress / 100,
                                      backgroundColor:
                                          SFColors.surface.withOpacity(0.3),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        SFColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${post.progress}%',
                                  style: TextStyle(
                                    color: SFColors.surface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  post.content,
                  style: TextStyle(color: SFColors.textPrimary),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.favorite,
                          count: post.likes,
                          color: SFColors.neutral,
                        ),
                        const SizedBox(width: 16),
                        _buildActionButton(
                          icon: Icons.chat_bubble_outline,
                          count: post.comments.length,
                          color: SFColors.tertiary,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: SFColors.textSecondary,
                      ),
                      onPressed: () => setState(() {
                        expandedPost =
                            isExpanded ? null : int.tryParse(post.id) ?? 0;
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isExpanded) _buildComments(post),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(
            color: SFColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildComments(Post post) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SFColors.background,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: SFColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Comments list would go here
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SFColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildAppBar(context)),
          SliverToBoxAdapter(child: _buildChallengeHub()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildPost(posts[index]),
              childCount: posts.length,
            ),
          ),
        ],
      ),
    );
  }
}