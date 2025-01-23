import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/features/tracking/presentation/alcohol/pages/alcohol_page.dart';
import 'package:seventy_five_hard/features/tracking/presentation/diet/pages/diet_page.dart';
import 'package:seventy_five_hard/features/tracking/presentation/pages/water_tracking.dart';
import 'package:seventy_five_hard/features/tracking/presentation/pages/workout_tracking.dart';
import 'package:seventy_five_hard/features/tracking/presentation/reading/pages/reading_page.dart';
import 'package:seventy_five_hard/features/user/presentation/bloc/user_bloc.dart';
import 'package:seventy_five_hard/features/user/presentation/bloc/user_event.dart';
import 'package:seventy_five_hard/features/user/presentation/bloc/user_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late List<AnimationController> _iconControllers;
  late List<Animation<double>> _iconAnimations;
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

    // Initialize floating icon animations
    _iconControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: Duration(milliseconds: 2000 + (index * 500)),
        vsync: this,
      ),
    );

    _iconAnimations = _iconControllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    // Start the animations
    for (var controller in _iconControllers) {
      controller.repeat(reverse: true);
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
    for (var controller in _iconControllers) {
      controller.dispose();
    }
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
                    Theme.of(context).colorScheme.primaryFixed.withOpacity(0.9),
                    Theme.of(context).colorScheme.tertiary,
                  ]
                : [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.background,
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
      {
        "title": "Diet",
        "icon": Icons.restaurant,
        "color": Theme.of(context).colorScheme.primary
      },
      {
        "title": "Outside Workout",
        "icon": Icons.directions_run,
        "color": Theme.of(context).colorScheme.tertiary
      },
      {
        "title": "Second Workout",
        "icon": Icons.fitness_center,
        "color": Theme.of(context).colorScheme.primaryFixed
      },
      {
        "title": "Water",
        "icon": Icons.water_drop,
        "color": Theme.of(context).colorScheme.secondary
      },
      {
        "title": "Alcohol",
        "icon": Icons.no_drinks,
        "color": const Color(0xFFB23B3B)
      },
      {
        "title": "10 Pages",
        "icon": Icons.menu_book,
        "color": Theme.of(context).colorScheme.primaryFixed.withOpacity(0.8)
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85, // Adjusted for new content
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
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
  }

  Widget _buildAppBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryFixed.withOpacity(0.15),
            Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primaryFixed.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                ).createShader(bounds),
                child: Text(
                  "DAY ${DateTime.now().difference(DateTime(2024, 1, 1)).inDays + 1}",
                  style: GoogleFonts.orbitron(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.9),
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  "Let's Crush It, $username!",
                  style: GoogleFonts.rajdhani(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                    height: 1.1,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
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
        itemCount:
            motivationalMessages.length * 10, // Increased for smoother looping
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
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
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
            color: Theme.of(context).colorScheme.surface,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryFixed.withOpacity(0.25),
              Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
            ],
            stops: const [0.3, 0.9],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Large background icon
            Positioned(
              right: -15,
              bottom: -15,
              child: Icon(
                icon,
                size: 90,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.07),
              ),
            ),
            // Main content column
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.2),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.25),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.orbitron(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.surface,
                    letterSpacing: 0.8,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Start button
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'START',
                        style: GoogleFonts.rajdhani(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.surface,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _randomPosition(double max) {
    return Random().nextDouble() * max;
  }

  void _navigateToPage(BuildContext context, String title) {
    final content = switch (title) {
      "Diet" => const DietPage(),
      "Outside Workout" => const WorkoutTrackingPage(isOutdoor: true),
      "Second Workout" => const WorkoutTrackingPage(isOutdoor: false),
      "Water" => const WaterTrackingPage(),
      "Alcohol" => const AlcoholPage(),
      "10 Pages" => const ReadingPage(),
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
