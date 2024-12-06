import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/features/presentation/outside_workout/ui/w1_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/alcohol_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/diet_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/ten_pages_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/w2_page.dart';
import 'package:seventy_five_hard/features/presentation/pages/water_page.dart';
import 'package:seventy_five_hard/features/presentation/users/bloc/user_bloc.dart';
import 'package:seventy_five_hard/themes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  Timer? _scrollTimer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final UserBloc userBloc = UserBloc();
  
  final List<String> motivationalMessages = [
    '💪 EMBRACE THE CHALLENGE',
    '🔥 NO EXCUSES TODAY',
    '⚡ UNLEASH YOUR POTENTIAL',
    '🌟 MAKE IT HAPPEN',
    '🏃 KEEP PUSHING FORWARD',
    '💫 BELIEVE IN YOURSELF',
    '🎯 STAY FOCUSED',
    '⭐ YOU\'RE CRUSHING IT',
  ];

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      userBloc.add(FetchUserName(user!.uid));
    }
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _startScrolling();
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startScrolling() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        double newOffset = _scrollController.offset + 1;
        if (newOffset >= _scrollController.position.maxScrollExtent) {
          newOffset = 0;
        }
        _scrollController.jumpTo(newOffset);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
                ? [
                    SFColors.neutral.withOpacity(0.9),
                    SFColors.tertiary,
                  ]
                : [
                    SFColors.surface,
                    SFColors.background,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(theme),
              _buildMotivationalTicker(theme),
              const SizedBox(height: 20),
              _buildDailyProgress(theme),
              const SizedBox(height: 20),
              Expanded(child: _buildChallengeGrid(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeGrid(ThemeData theme) {
    final challenges = [
      {"title": "Diet", "icon": Icons.restaurant, "color": SFColors.primary},
      {"title": "Outside Workout", "icon": Icons.directions_run, "color": SFColors.tertiary},
      {"title": "Second Workout", "icon": Icons.fitness_center, "color": SFColors.neutral},
      {"title": "Water", "icon": Icons.water_drop, "color": SFColors.secondary},
      {"title": "Alcohol", "icon": Icons.no_drinks, "color": const Color(0xFFB23B3B)},
      {"title": "10 Pages", "icon": Icons.menu_book, "color": SFColors.neutral.withOpacity(0.8)},
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return _buildChallengeCard(
          title: challenge["title"] as String,
          icon: challenge["icon"] as IconData,
          color: challenge["color"] as Color,
          theme: theme,
        );
      },
    );
  }  Widget _buildAppBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: BlocConsumer<UserBloc, UserState>(
        bloc: userBloc,
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          String username = state is UserLoaded ? state.username : "Warrior";
          return Column(
            children: [
              Text(
                "DAY ${DateTime.now().difference(DateTime(2024, 1, 1)).inDays + 1}",
                style: GoogleFonts.orbitron(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Let's Crush It, $username!",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

 Widget _buildMotivationalTicker(ThemeData theme) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: motivationalMessages.length * 10, // Increased for smoother looping
        itemBuilder: (context, index) {
          final itemIndex = index % motivationalMessages.length;
          return _buildMotivationalItem(
            motivationalMessages[itemIndex],
            theme,
            itemIndex,
          );
        },
      ),
    );
  }
  Widget _buildMotivationalItem(String message, ThemeData theme, int index) {
    final colors = [
      SFColors.primary,
      SFColors.secondary,
      SFColors.tertiary,
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors[index % colors.length],
            colors[(index + 1) % colors.length],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: colors[index % colors.length].withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.inter(
            color: SFColors.surface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDailyProgress(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            "TODAY'S PROGRESS",
            style: GoogleFonts.orbitron(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressItem("2/6", "Tasks\nComplete", theme),
              _buildProgressItem("33%", "Day\nProgress", theme),
              _buildProgressItem("🔥 3", "Day\nStreak", theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String value, String label, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
      ],
    );
  }



  Widget _buildChallengeCard({
    required String title,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: () => _navigateToPage(context, title),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Tap to Start",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _navigateToPage(BuildContext context, String title) {
    // Instead of navigation, use a callback or state management
    // to show these pages within the same tab
    final content = switch(title) {
      "Diet" => const DietPage(),
      "Outside Workout" => const WorkoutOnePage(),
      "Second Workout" => const WorkoutTwoPage(),
      "Water" => const WaterPage(),
      "Alcohol" => const AlcoholPage(),
      "10 Pages" => const TenPagesPage(),
      _ => null
    };

    if (content != null) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => content,
        ),
      );
    }
  }
}