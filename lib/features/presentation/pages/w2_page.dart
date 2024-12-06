import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class WorkoutTwoPage extends StatefulWidget {
  const WorkoutTwoPage({Key? key}) : super(key: key);

  @override
  _WorkoutTwoPageState createState() => _WorkoutTwoPageState();
}

class _WorkoutTwoPageState extends State<WorkoutTwoPage>
    with TickerProviderStateMixin {
  final TextEditingController _workoutDescriptionController =
      TextEditingController();
  final TextEditingController _reflectionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  User? user;
  bool _isLoading = false;
  bool _isSubmitting = false;
  int _selectedWorkoutType = 0;

  final List<Map<String, dynamic>> workoutTypes = [
    {
      'name': 'Strength',
      'icon': Icons.fitness_center,
      'gradient': [Color(0xFF047E55), Color(0xFF48BF84)],
    },
    {
      'name': 'Cardio',
      'icon': Icons.directions_run,
      'gradient': [Color(0xFF5A7D9A), Color(0xFF89A7C4)],
    },
    {
      'name': 'HIIT',
      'icon': Icons.timer,
      'gradient': [Color(0xFF2E7D32), Color(0xFF4CAF50)],
    },
    {
      'name': 'Yoga',
      'icon': Icons.self_improvement,
      'gradient': [Color(0xFFBF9648), Color(0xFFDFB668)],
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            workoutTypes[_selectedWorkoutType]['gradient']?[0] ?? Colors.blue,
            workoutTypes[_selectedWorkoutType]['gradient']?[1] ?? Colors.green,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: workoutTypes[_selectedWorkoutType]['gradient']?[0]
                    ?.withOpacity(0.3) ??
                Colors.grey.withOpacity(0.3),
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
                    'Second Workout',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Day 2 of 75',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
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
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: workoutTypes.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedWorkoutType == index;
          final type = workoutTypes[index];

          return GestureDetector(
            onTap: () => setState(() => _selectedWorkoutType = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 100,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSelected
                      ? type['gradient'] ?? [Colors.blue, Colors.green]
                      : [Colors.grey.shade200, Colors.grey.shade400],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? (type['gradient']?[0]?.withOpacity(0.3) ??
                            Colors.grey.withOpacity(0.3))
                        : Colors.grey.withOpacity(0.1),
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
                    color: isSelected ? Colors.white : Colors.grey,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    type['name'],
                    style: GoogleFonts.inter(
                      color: isSelected ? Colors.white : Colors.black,
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

  Widget _buildWorkoutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWorkoutTypeSelector(),
          const SizedBox(height: 16),
          _buildPromptCards(),
          const SizedBox(height: 24),
          _buildWorkoutInputCard(),
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
                colors: workoutTypes[_selectedWorkoutType]['gradient'] ??
                    [Colors.blue, Colors.green],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Details',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _workoutDescriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Describe your workout...',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildWorkoutTab(),
        Center(
          child: Text(
            'Reflection Coming Soon',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Workout'),
                Tab(text: 'Reflection'),
              ],
            ),
            Expanded(
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }
}
