import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/themes.dart';
import '../models/water_model.dart';
import '../models/day_model.dart';
import 'dart:math' as math;

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  @override
  _WaterPageState createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> with TickerProviderStateMixin {
  double _remainingWaterOunces = 128.0;
  int _bathroomCounter = 0;
  bool _showMotivation = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  User? user;
  Day? day;
  Water? water;
  DateTime today = DateTime.now();
  bool _isLoading = false;

  final List<String> _motivationalQuotes = [
    "Stay hydrated, stay strong! 💪",
    "Every sip brings you closer to your goal! 🎯",
    "Hydration is key to success! 🔑",
    "You're crushing it! Keep drinking! 🌊",
    "Water is fuel for champions! 🏆"
  ];

  final List<String> _bathroomMessages = [
    "Time to go! 🚽",
    "Nature calls! 🌊",
    "Break time! ⏰",
    "The throne awaits! 👑",
    "Gotta go, gotta go! 🏃‍♂️",
  ];

  String get _randomQuote {
    return _motivationalQuotes[math.Random().nextInt(_motivationalQuotes.length)];
  }

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _waveAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.linear),
    );

    _fetchDayData();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  // [Previous API methods remain the same]
  Future<void> _fetchDayData() async {
    if (user == null) return;
    setState(() => _isLoading = true);

    String formattedDate = today.toString().substring(0, 10);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user!.uid}/$formattedDate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          day = Day.fromJson(json.decode(response.body));
          water = day!.water;
          _bathroomCounter = water?.peeCount ?? 0;
          _remainingWaterOunces = water?.completed == true ? 0 : 128;
          _showMotivation = water?.completed == true;
        });
      } else {
        _showErrorSnackBar('Failed to load hydration data');
      }
    } catch (e) {
      _showErrorSnackBar('Error loading data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateWaterData() async {
    if (user == null || water == null) return;

    water!.completed = _remainingWaterOunces == 0;
    water!.peeCount = _bathroomCounter;
    water!.ouncesDrunk = (128.0 - _remainingWaterOunces).toInt();
    final Map<String, dynamic> waterData = water!.toJson();

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'water': waterData}),
      );

      if (response.statusCode == 200) {
        if (_remainingWaterOunces == 0) {
          _showSuccessSnackBar('Daily water goal achieved! 🎉');
        }
      } else {
        _showErrorSnackBar('Failed to update progress');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving progress');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildWaterBottle(),
                      const SizedBox(height: 24),
                      _buildQuickActions(),
                      const SizedBox(height: 24),
                      _buildBathroomTracker(),
                      if (_showMotivation) ...[
                        const SizedBox(height: 24),
                        _buildMotivationCard(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.secondaryFixed,
            Theme.of(context).colorScheme.tertiary,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hydration Station',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Day ${today.difference(DateTime(2024, 1, 1)).inDays + 1} of 75',
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              _buildProgressRing(),
            ],
          ),
          const SizedBox(height: 20),
          _buildWaterStats(),
        ],
      ),
    );
  }


  Widget _buildProgressRing() {
    final progress = (128 - _remainingWaterOunces) / 128;
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface.withOpacity(0.2),
            Theme.of(context).colorScheme.surface.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Text(
          '${(progress * 100).toInt()}%',
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    );
  }


  Widget _buildWaterStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildWaterStatItem(
          icon: Icons.water_drop,
          value: '${(128 - _remainingWaterOunces).toInt()}',
          label: 'Ounces',
        ),
        _buildWaterStatItem(
          icon: Icons.local_fire_department,
          value: '$_bathroomCounter',
          label: 'Breaks',
        ),
        _buildWaterStatItem(
          icon: Icons.timer,
          value: _remainingWaterOunces == 0 ? '100%' : '${((128 - _remainingWaterOunces) / 128 * 100).toInt()}%',
          label: 'Progress',
        ),
      ],
    );
  }

  Widget _buildWaterStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.surface, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaterBottle() {
    return Container(
      height: 250,
      width: 120,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return ClipPath(
                clipper: WaveClipper(
                  animation: _waveAnimation.value,
                  fillPercentage: water!.ouncesDrunk! / 128.0 ,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
                        Theme.of(context).colorScheme.tertiary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: -85,
            top: 0,
            bottom: 0,
            child: RotatedBox(
              quarterTurns: 3,
              child: SizedBox(
                width: 250,
                child: Slider(
                  value: _remainingWaterOunces,
                  min: 0,
                  max: 128,
                  divisions: 128,
                  onChanged: _updateWaterLevel,
                  activeColor: Theme.of(context).colorScheme.tertiary,
                  inactiveColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionButton(
          value: 8,
          label: '8 oz',
        ),
        _buildQuickActionButton(
          value: 16,
          label: '16 oz',
        ),
        _buildQuickActionButton(
          value: 32,
          label: '32 oz',
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required double value,
    required String label,
  }) {
    return GestureDetector(
      onTap: () => _addWater(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.secondaryFixed, Theme.of(context).colorScheme.tertiary],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.water_drop, color: Theme.of(context).colorScheme.surface),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBathroomTracker() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _bathroomMessages[_bathroomCounter % _bathroomMessages.length],
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFunCounterButton(
                icon: Icons.remove,
                onPressed: _decrementPeeCount,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      '🚽 × $_bathroomCounter',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildFunCounterButton(
                icon: Icons.add,
                onPressed: _incrementPeeCount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFunCounterButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.secondaryFixed, Theme.of(context).colorScheme.tertiary],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.surface,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildMotivationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.secondaryFixed, Theme.of(context).colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events,
            color: Theme.of(context).colorScheme.surface,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            _randomQuote,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }

  void _updateWaterLevel(double newValue) {
    setState(() {
      _remainingWaterOunces = newValue;
      _showMotivation = newValue == 0;
    });
    _updateWaterData();
  }

  void _addWater(double ounces) {
    double newValue = math.max(0, _remainingWaterOunces - ounces);
    _updateWaterLevel(newValue);
  }

  void _incrementPeeCount() {
    setState(() => _bathroomCounter++);
    _updateWaterData();
  }

  void _decrementPeeCount() {
    if (_bathroomCounter > 0) {
      setState(() => _bathroomCounter--);
      _updateWaterData();
    }
  }
 void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.surface),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(Icons.error_outline, color: Theme.of(context).colorScheme.surface),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: const Color(0xFFB23B3B),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;
  final double fillPercentage;

  WaveClipper({
    required this.animation,
    required this.fillPercentage,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final baseHeight = size.height * (1 - fillPercentage);

    path.moveTo(0, size.height);
    path.lineTo(0, baseHeight);

    for (var i = 0.0; i <= size.width; i++) {
      path.lineTo(
        i,
        baseHeight + math.sin((i / size.width * 2 * math.pi) + animation) * 10,
      );
    }

    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation ||
      fillPercentage != oldClipper.fillPercentage;
}