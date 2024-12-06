import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/themes.dart';

class WorkoutOnePage extends StatefulWidget {
  const WorkoutOnePage({Key? key}) : super(key: key);

  @override
  _WorkoutOnePageState createState() => _WorkoutOnePageState();
}

class _WorkoutOnePageState extends State<WorkoutOnePage>
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
      'gradient': [SFColors.primary, SFColors.secondary],
    },
    {
      'name': 'Cardio',
      'icon': Icons.directions_run,
      'gradient': [SFColors.tertiary, SFColors.neutral],
    },
    {
      'name': 'HIIT',
      'icon': Icons.timer,
      'gradient': [SFColors.primary, SFColors.tertiary],
    },
    {
      'name': 'Yoga',
      'icon': Icons.self_improvement,
      'gradient': [SFColors.neutral, SFColors.secondary],
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
          colors: workoutTypes[_selectedWorkoutType]['gradient'],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: (workoutTypes[_selectedWorkoutType]['gradient'][0] as Color).withOpacity(0.3),
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
                    'First Workout',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: SFColors.surface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Day 2 of 75',
                    style: GoogleFonts.inter(
                      color: SFColors.surface.withOpacity(0.9),
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
                      ? type['gradient']
                      : [SFColors.background, SFColors.background],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? (type['gradient'][0] as Color).withOpacity(0.3)
                        : SFColors.neutral.withOpacity(0.1),
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
                    color: isSelected ? SFColors.surface : SFColors.textSecondary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    type['name'],
                    style: GoogleFonts.inter(
                      color: isSelected ? SFColors.surface : SFColors.textPrimary,
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
                colors: workoutTypes[_selectedWorkoutType]['gradient'],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                _workoutPrompts[index],
                style: GoogleFonts.poppins(
                  color: SFColors.surface,
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
        color: SFColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: SFColors.neutral.withOpacity(0.1),
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
              color: SFColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _workoutDescriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Describe your workout...',
              filled: true,
              fillColor: SFColors.background,
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
      body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
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
      ),
    );
  }
}