// lib/features/home/ui/home_page.dart
import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:seventy_five_hard/features/home/controllers/home_controller.dart';
import 'package:seventy_five_hard/features/tracking/presentation/alcohol/pages/alcohol_page.dart';
import 'package:seventy_five_hard/features/tracking/presentation/diet/pages/diet_page.dart';
import 'package:seventy_five_hard/features/tracking/presentation/water/pages/water_page.dart';
import 'package:seventy_five_hard/features/tracking/presentation/reading/pages/reading_page.dart';
import 'package:seventy_five_hard/features/tracking/presentation/workout/pages/workout_page.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';

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
  late HomeController _homeController;
  
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
    _homeController = HomeController();
    _homeController.initialize();
    
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

    return ChangeNotifierProvider.value(
      value: _homeController,
      child: Scaffold(
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
          child: Consumer<HomeController>(
            builder: (context, controller, _) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              return RefreshIndicator(
                onRefresh: () => controller.refresh(),
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(theme, controller),
                      _buildMotivationalTicker(theme),
                      const SizedBox(height: 20),
                      _buildDailyProgress(theme, controller),
                      const SizedBox(height: 20),
                      Expanded(child: _buildChallengeGrid(theme)),
                    ],
                  ),
                ),
              );
            },
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
        "color": Theme.of(context).colorScheme.primary,
        "isCompleted": _homeController.todayData?.diet?.completed ?? false,
      },
      {
        "title": "Outside Workout",
        "icon": Icons.directions_run,
        "color": Theme.of(context).colorScheme.tertiary,
        "isCompleted": _homeController.todayData?.outsideWorkout?.completed ?? false,
      },
      {
        "title": "Inside Workout",
        "icon": Icons.fitness_center,
        "color": Theme.of(context).colorScheme.primaryFixed,
        "isCompleted": _homeController.todayData?.insideWorkout?.completed ?? false,
      },
      {
        "title": "Water",
        "icon": Icons.water_drop,
        "color": Theme.of(context).colorScheme.secondary,
        "isCompleted": _homeController.todayData?.water?.completed ?? false,
      },
      {
        "title": "No Alcohol",
        "icon": Icons.no_drinks,
        "color": const Color(0xFFB23B3B),
        "isCompleted": _homeController.todayData?.alcohol?.completed ?? false,
      },
      {
        "title": "Reading",
        "icon": Icons.menu_book,
        "color": Theme.of(context).colorScheme.primaryFixed.withOpacity(0.8),
        "isCompleted": _homeController.todayData?.pages?.completed ?? false,
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
          isCompleted: challenge["isCompleted"] as bool,
          theme: theme,
        );
      },
    );
  }

  Widget _buildAppBar(ThemeData theme, HomeController controller) {
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
      child: Column(
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              "Let's Crush It, ${controller.username}!",
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

  Widget _buildDailyProgress(ThemeData theme, HomeController controller) {
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
              _buildProgressItem(
                "${controller.completedTasks}/6", 
                "Tasks\nComplete", 
                theme
              ),
              _buildProgressItem(
                "${(controller.dayProgress * 100).toInt()}%", 
                "Day\nProgress", 
                theme
              ),
              _buildProgressItem(
                "🔥 ${controller.streakCount}", 
                "Day\nStreak", 
                theme
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: controller.dayProgress,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.dayProgress >= 1.0 
                ? "All tasks completed! Great job!" 
                : "Keep going! ${6 - controller.completedTasks} more to go!",
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
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
    required bool isCompleted,
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
            colors: isCompleted
                ? [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ]
                : [
                    Theme.of(context).colorScheme.primaryFixed.withOpacity(0.25),
                    Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
                  ],
            stops: const [0.3, 0.9],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isCompleted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.3),
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
                color: isCompleted
                    ? Colors.white.withOpacity(0.1)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.07),
              ),
            ),
            // Completed indicator
            if (isCompleted)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
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
                      colors: isCompleted
                          ? [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.2)]
                          : [
                              Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                            ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isCompleted
                            ? Colors.white.withOpacity(0.2)
                            : Theme.of(context).colorScheme.primary.withOpacity(0.25),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 30,
                    color: isCompleted
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
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
                    color: isCompleted
                        ? Colors.white
                        : Theme.of(context).colorScheme.surface,
                    letterSpacing: 0.8,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Start button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isCompleted
                          ? [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.2)]
                          : [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCompleted ? Icons.check : Icons.play_arrow_rounded,
                        size: 18,
                        color: isCompleted 
                            ? Colors.white 
                            : Theme.of(context).colorScheme.surface,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isCompleted ? 'DONE' : 'START',
                        style: GoogleFonts.rajdhani(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isCompleted 
                              ? Colors.white 
                              : Theme.of(context).colorScheme.surface,
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
      "Outside Workout" => const WorkoutPage(isOutside: true),
      "Inside Workout" => const WorkoutPage(isOutside: false),
      "Water" => const WaterPage(),
      "No Alcohol" => const AlcoholPage(),
      "Reading" => const ReadingPage(),
      _ => null
    };

    if (content != null) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => content,
        ),
      ).then((_) {
        // Refresh data when returning from tracking pages
        _homeController.refresh();
      });
    }
  }
}