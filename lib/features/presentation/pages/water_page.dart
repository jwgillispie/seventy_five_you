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

  String get _randomQuote {
    return _motivationalQuotes[
        math.Random().nextInt(_motivationalQuotes.length)];
  }

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;

    // Wave Animation Controller
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Wave Animation
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
    final Map<String, dynamic> waterData = water!.toJson();

    try {
      final response = await http.put(
        Uri.parse(
            'http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
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

  void _updateWaterLevel(double newValue) {
    setState(() {
      _remainingWaterOunces = newValue;
      _showMotivation = newValue == 0;
    });
    _updateWaterData();
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

  void _addWater(double ounces) {
    double newValue = math.max(0, _remainingWaterOunces - ounces);
    _updateWaterLevel(newValue);
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(),
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
              'Loading your hydration tracker...',
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '75 Hard: Hydration',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: SFColors.primary,
                ),
              ),
              Text(
                'Day ${today.day}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: SFColors.textSecondary,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SFColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(128 - _remainingWaterOunces).toInt()} / 128 oz',
              style: GoogleFonts.poppins(
                color: SFColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterBottle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AspectRatio(
        aspectRatio: 0.4,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: SFColors.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Water Wave Animation
              AnimatedBuilder(
                animation: _waveAnimation,
                builder: (context, child) {
                  return ClipPath(
                    clipper: WaveClipper(
                      animation: _waveAnimation.value,
                      fillPercentage: _remainingWaterOunces / 128.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            SFColors.primary.withOpacity(0.6),
                            SFColors.primary,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Measurement Lines
              ...List.generate(5, (index) {
                return Positioned(
                  left: 0,
                  top: (index + 1) *
                      (MediaQuery.of(context).size.height * 0.4) /
                      6,
                  child: Container(
                    width: 20,
                    height: 2,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                );
              }),
              // Slider
              Positioned(
                right: -70,
                top: 0,
                bottom: 0,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.height * 0.4,
                    child: Slider(
                      value: _remainingWaterOunces,
                      min: 0,
                      max: 128,
                      divisions: 128,
                      onChanged: _updateWaterLevel,
                      activeColor: SFColors.primary,
                      inactiveColor: SFColors.primary.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionButton(
            icon: Icons.water_drop,
            label: '8 oz',
            onPressed: () => _addWater(8),
          ),
          _buildQuickActionButton(
            icon: Icons.water_drop,
            label: '16 oz',
            onPressed: () => _addWater(16),
          ),
          _buildQuickActionButton(
            icon: Icons.water_drop,
            label: '32 oz',
            onPressed: () => _addWater(32),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: SFColors.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: SFColors.primary,
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
                Icons.water_drop,
                color: SFColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Bathroom Visits',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: SFColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCounterButton(
                icon: Icons.remove,
                onPressed: _decrementPeeCount,
              ),
              const SizedBox(width: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: SFColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _bathroomCounter.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: SFColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              _buildCounterButton(
                icon: Icons.add,
                onPressed: _incrementPeeCount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: SFColors.primary),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: SFColors.primary,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildMotivationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            _randomQuote,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
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

    // Create wave effect
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
