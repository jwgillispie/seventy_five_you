import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/features/presentation/models/day_model.dart';
import 'package:seventy_five_hard/features/presentation/models/inside_workout_model.dart';
import 'package:seventy_five_hard/themes.dart';


class WorkoutTwoPage extends StatefulWidget {
  const WorkoutTwoPage({Key? key}) : super(key: key);

  @override
  _WorkoutTwoPageState createState() => _WorkoutTwoPageState();
}

class _WorkoutTwoPageState extends State<WorkoutTwoPage> with TickerProviderStateMixin {
  final TextEditingController _workoutDescriptionController = TextEditingController();
  final TextEditingController _reflectionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  
  User? user;
  Day? day;
  InsideWorkout? insideWorkout;
  DateTime today = DateTime.now();
  bool _isLoading = false;
  bool _isSubmitting = false;
  int _selectedWorkoutType = 0;

  final List<Map<String, dynamic>> workoutTypes = [
    {
      'name': 'Strength',
      'icon': Icons.fitness_center,
      'color': Color(0xFFFF6B6B),
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    },
    {
      'name': 'Cardio',
      'icon': Icons.directions_run,
      'color': Color(0xFF4ECDC4),
      'gradient': [Color(0xFF4ECDC4), Color(0xFF6EE7E0)],
    },
    {
      'name': 'HIIT',
      'icon': Icons.timer,
      'color': Color(0xFFFFBE0B),
      'gradient': [Color(0xFFFFBE0B), Color(0xFFFFD23F)],
    },
    {
      'name': 'Yoga',
      'icon': Icons.self_improvement,
      'color': Color(0xFF9B5DE5),
      'gradient': [Color(0xFF9B5DE5), Color(0xFFB785EC)],
    },
  ];

  final List<String> _workoutPrompts = [
    'What exercises did you perform?',
    'How many sets and reps?',
    'What was the intensity level?',
    'Did you try any new exercises?',
  ];

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _fetchDayData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _workoutDescriptionController.dispose();
    _reflectionController.dispose();
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ... [Previous API methods remain the same] ...
   Future<void> _submitData(String type) async {
    if (user == null || insideWorkout == null) return;
    setState(() => _isLoading = true);

    if (type == 'workout') {
      insideWorkout!.description = _workoutDescriptionController.text;
    } else {
      insideWorkout!.thoughts = _reflectionController.text;
    }

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'inside_workout': insideWorkout!.toJson()}),
      );

      if (response.statusCode == 200) {
        _showSuccessSnackBar(type == 'workout' 
          ? 'Workout saved successfully! Keep pushing!' 
          : 'Reflection saved! Great job reflecting on your progress!');
      } else {
        _showErrorSnackBar('Failed to save ${type}. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving ${type}');
    } finally {
      setState(() => _isLoading = false);
    }
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
          insideWorkout = day!.insideWorkout;
          if (insideWorkout != null) {
            _workoutDescriptionController.text = insideWorkout!.description ?? '';
            _reflectionController.text = insideWorkout!.thoughts ?? '';
          }
        });
      }
    } catch (e) {
      _showErrorSnackBar("Error fetching workout data");
    } finally {
      setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _buildLoadingState()
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SFColors.primary.withOpacity(0.05),
                    Colors.white,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                _buildWorkoutTypeSelector(),
                                _buildTabBar(),
                              ],
                            ),
                          ),
                          SliverFillRemaining(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildWorkoutTab(),
                                _buildReflectionTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(SFColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading your workout space...',
            style: GoogleFonts.poppins(
              color: SFColors.primary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: SFColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: SFColors.primary),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Morning Workout',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: SFColors.primary,
                ),
              ),
              Text(
                'Day ${today.day} of 75',
                style: GoogleFonts.poppins(
                  color: SFColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutTypeSelector() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: workoutTypes.length,
        itemBuilder: (context, index) {
          final type = workoutTypes[index];
          final isSelected = _selectedWorkoutType == index;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedWorkoutType = index),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSelected ? type['gradient'] : [Colors.white, Colors.white],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected ? type['color'].withOpacity(0.3) : Colors.transparent,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    type['icon'],
                    color: isSelected ? Colors.white : type['color'],
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    type['name'],
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : SFColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: SFColors.primary,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: SFColors.textSecondary,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Workout'),
          Tab(text: 'Reflection'),
        ],
      ),
    );
  }

  Widget _buildWorkoutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPromptCards(),
          const SizedBox(height: 24),
          _buildWorkoutInputCard(),
          const SizedBox(height: 24),
          _buildMetricsGrid(),
          const SizedBox(height: 24),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildPromptCards() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _workoutPrompts.length,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  workoutTypes[_selectedWorkoutType]['color'].withOpacity(0.8),
                  workoutTypes[_selectedWorkoutType]['color'],
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                _workoutPrompts[index],
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutInputCard() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Details',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: SFColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _workoutDescriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Describe your workout...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: SFColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    final metrics = [
      {'label': 'Time', 'value': '45 min', 'icon': Icons.timer},
      {'label': 'Intensity', 'value': 'High', 'icon': Icons.trending_up},
      {'label': 'Energy', 'value': '325 kcal', 'icon': Icons.local_fire_department},
      {'label': 'Mood', 'value': 'Great', 'icon': Icons.mood},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                metric['icon'] as IconData,
                color: workoutTypes[_selectedWorkoutType]['color'],
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                metric['value'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                metric['label'] as String,
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReflectionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildReflectionCard(),
          const SizedBox(height: 24),
          _buildMoodSelector(),
          const SizedBox(height: 24),
          _buildSubmitButton(),
        ],
      ),
    );
  }

Widget _buildReflectionCard() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: workoutTypes[_selectedWorkoutType]['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.psychology,
                  color: workoutTypes[_selectedWorkoutType]['color'],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Workout Reflection',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: SFColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _reflectionController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'How did you feel during the workout? What challenged you the most? What would you do differently next time?',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: SFColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    final moods = [
      {'emoji': '😤', 'label': 'Pumped'},
      {'emoji': '💪', 'label': 'Strong'},
      {'emoji': '😅', 'label': 'Challenged'},
      {'emoji': '🎯', 'label': 'Focused'},
      {'emoji': '🌟', 'label': 'Accomplished'},
    ];

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling?',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: SFColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: moods.map((mood) => Column(
              children: [
                Text(
                  mood['emoji']!,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 4),
                Text(
                  mood['label']!,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: workoutTypes[_selectedWorkoutType]['color'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save_outlined),
                  const SizedBox(width: 8),
                  Text(
                    'Save Workout',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_workoutDescriptionController.text.isEmpty) {
      _showErrorSnackBar('Please describe your workout');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      if (_tabController.index == 0) {
        await _submitData('workout');
        _tabController.animateTo(1);
      } else {
        await _submitData('reflection');
        Navigator.pop(context);
      }
    } finally {
      setState(() => _isSubmitting = false);
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
      backgroundColor: workoutTypes[_selectedWorkoutType]['color'],
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
      backgroundColor: Colors.red.shade800,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}