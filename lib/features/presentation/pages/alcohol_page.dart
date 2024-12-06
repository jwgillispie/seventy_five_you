import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seventy_five_hard/themes.dart';
import '../models/alcohol_model.dart';
import '../models/day_model.dart';
import 'dart:math' as math;

class AlcoholPage extends StatefulWidget {
  const AlcoholPage({Key? key}) : super(key: key);

  @override
  State<AlcoholPage> createState() => _AlcoholPageState();
}

class _AlcoholPageState extends State<AlcoholPage>
    with TickerProviderStateMixin {
  double _rating = 5.0;
  bool _avoidedAlcohol = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _strengthAnimation;
  late Animation<Offset> _slideAnimation;

  User? user;
  Alcohol? alcohol;
  DateTime today = DateTime.now();
  bool _isLoading = false;
  bool _showStreak = false;

  final List<String> _achievements = [
    "1 Day Milestone 🌟",
    "1 Week Strong 💪",
    "Health Boost 🏃‍♂️",
    "Money Saved 💰",
    "Better Sleep 😴",
  ];

  final List<Map<String, dynamic>> _benefitsData = [
    {
      'title': 'Mental Clarity',
      'icon': Icons.psychology,
      'color': Color(0xFF4ECDC4),
      'progress': 0.85,
    },
    {
      'title': 'Energy Level',
      'icon': Icons.bolt,
      'color': Color(0xFFFFBE0B),
      'progress': 0.75,
    },
    {
      'title': 'Sleep Quality',
      'icon': Icons.nightlight_round,
      'color': Color(0xFF9B5DE5),
      'progress': 0.90,
    },
    {
      'title': 'Money Saved',
      'icon': Icons.savings,
      'color': Color(0xFF00B4D8),
      'progress': 1.0,
    },
  ];

  Widget _buildBenefitsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: _benefitsData.length,
      itemBuilder: (context, index) {
        final benefit = _benefitsData[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: benefit['color'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  benefit['icon'],
                  color: benefit['color'],
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                benefit['title'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: SFColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: benefit['progress'] * _strengthAnimation.value,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(benefit['color']),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;

    // Main animation controller
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Slide animation controller
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _strengthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _fetchAlcoholData();
    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // ... [Previous API methods remain the same] ...
  Future<void> _fetchAlcoholData() async {
    if (user == null) return;
    setState(() => _isLoading = true);

    String formattedDate = today.toString().substring(0, 10);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user!.uid}/$formattedDate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Day day = Day.fromJson(json.decode(response.body));
        setState(() {
          alcohol = day.alcohol;
          _avoidedAlcohol = alcohol?.completed ?? false;
          _rating = alcohol?.difficulty?.toDouble() ?? 5.0;
        });
      } else {
        _showErrorSnackBar('Failed to load data');
      }
    } catch (e) {
      _showErrorSnackBar('Error loading data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateAlcoholData() async {
    if (user == null || alcohol == null) return;

    alcohol!.completed = _avoidedAlcohol;
    alcohol!.difficulty = _rating.toInt();

    final Map<String, dynamic> alcoholData = alcohol!.toJson();
    try {
      final response = await http.put(
        Uri.parse(
            'http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'alcohol': alcoholData}),
      );

      if (response.statusCode == 200) {
        _showSuccessSnackBar(_avoidedAlcohol
            ? 'Great job staying alcohol-free today! 🎉'
            : 'Progress updated. Keep pushing forward! 💪');
      } else {
        _showErrorSnackBar('Failed to update progress');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving progress');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: SFColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: SFColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
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
          child: Stack(
            children: [
              // Animated background patterns
              ...List.generate(5, (index) {
                return Positioned(
                  left: math.Random().nextDouble() *
                      MediaQuery.of(context).size.width,
                  top: math.Random().nextDouble() * 200,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white.withOpacity(0.1),
                          size: 40 * (index + 1),
                        ),
                      );
                    },
                  ),
                );
              }),
              // Title and streak count
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '75 Hard: Alcohol-Free',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Day ${today.day}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStrengthMeter() {
    final strengthLevel = (_rating / 10.0);
    final strength = 1.0 - strengthLevel; // Invert the rating to show strength

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            strength > 0.7 ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
            strength > 0.7 ? const Color(0xFF81C784) : const Color(0xFFFFB74D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Strength Level',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(strength * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AnimatedBuilder(
                animation: _strengthAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: strength * _strengthAnimation.value,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      strength > 0.7
                          ? Colors.white
                          : Colors.white.withOpacity(0.8),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            strength > 0.7
                ? 'You\'re crushing it! 💪'
                : 'Stay strong, you got this! 🎯',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            SFColors.primary.withOpacity(0.05),
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(SFColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading your progress...',
              style: GoogleFonts.poppins(
                color: SFColors.primary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String ratingToDifficulty(double rating) {
    if (rating < 3) return 'Easy';
    if (rating < 7) return 'Moderate';
    if (rating < 10) return 'Hard';
    return 'Challenging';
  }

  Widget _buildDifficultySlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'How challenging was it?',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: SFColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: SFColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                ratingToDifficulty(_rating),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: SFColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.sentiment_very_satisfied, color: Colors.green),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: SFColors.primary,
                  inactiveTrackColor: SFColors.primary.withOpacity(0.2),
                  thumbColor: SFColors.primary,
                  overlayColor: SFColors.primary.withOpacity(0.2),
                  trackHeight: 8,
                ),
                child: Slider(
                  value: _rating,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() => _rating = value);
                    _updateAlcoholData();
                  },
                ),
              ),
            ),
            const Icon(Icons.sentiment_very_dissatisfied, color: Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildDailyCheckIn() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified,
                color: SFColors.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Daily Check-in',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: SFColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SFColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Alcohol-Free Today?',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: SFColors.textPrimary,
                  ),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Switch(
                    value: _avoidedAlcohol,
                    onChanged: (value) {
                      setState(() {
                        _avoidedAlcohol = value;
                        _showStreak = value;
                        if (value) {
                          _slideController.forward();
                        }
                      });
                      _updateAlcoholData();
                    },
                    activeColor: SFColors.primary,
                    activeTrackColor: SFColors.primary.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_avoidedAlcohol) ...[
            const SizedBox(height: 16),
            _buildDifficultySlider(),
          ],
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: SFColors.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Achievements',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: SFColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _achievements.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        SFColors.primary.withOpacity(0.8),
                        SFColors.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _achievements[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: SFColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: SFColors.primary.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'Current Streak',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Text(
                    '7 Days',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Personal Best: 14 Days',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _buildLoadingState()
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    SFColors.primary.withOpacity(0.05),
                    Colors.white,
                  ],
                ),
              ),
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    _buildSliverHeader(),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildStrengthMeter(),
                            const SizedBox(height: 24),
                            _buildBenefitsGrid(),
                            const SizedBox(height: 24),
                            _buildDailyCheckIn(),
                            const SizedBox(height: 24),
                            _buildAchievements(),
                            if (_showStreak) ...[
                              const SizedBox(height: 24),
                              _buildStreakCard(),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
