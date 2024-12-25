import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/themes.dart';

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
  DateTime today = DateTime.now();
  bool _completedWorkout = false;
  final List<String> _reflectionPrompts = [
    'How did this workout challenge you?',
    'What could you improve next time?',
    'Rate your energy level (1-10)',
    'What was your favorite part?',
  ];



  // final List<Map<String, dynamic>> workoutTypes = [
  //   {
  //     'name': 'Strength',
  //     'icon': Icons.fitness_center,
  //     'gradient': [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
  //   },
  //   {
  //     'name': 'Cardio',
  //     'icon': Icons.directions_run,
  //     'gradient': [Theme.of(context).colorScheme.tertiary, Theme.of(context).colorScheme.secondaryFixed],
  //   },
  //   {
  //     'name': 'HIIT',
  //     'icon': Icons.timer,
  //     'gradient': [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.tertiary],
  //   },
  //   {
  //     'name': 'Yoga',
  //     'icon': Icons.self_improvement,
  //     'gradient': [Theme.of(context).colorScheme.secondaryFixed, Theme.of(context).colorScheme.secondary],
  //   },
  // ];


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
    _fetchWorkoutData();  // Add this line
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
      final workoutTypes = getWorkoutTypes(context);

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
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Day 2 of 75',
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
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
List<Map<String, dynamic>> getWorkoutTypes(BuildContext context) {
  return [
    {
      'name': 'Strength',
      'icon': Icons.fitness_center,
      'gradient': [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.secondary,
      ],
    },
    {
      'name': 'Cardio',
      'icon': Icons.directions_run,
      'gradient': [
        Theme.of(context).colorScheme.tertiary,
        Theme.of(context).colorScheme.secondary,
      ],
    },
    {
      'name': 'HIIT',
      'icon': Icons.timer,
      'gradient': [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.tertiary,
      ],
    },
    {
      'name': 'Yoga',
      'icon': Icons.self_improvement,
      'gradient': [
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.primary,
      ],
    },
  ];
}
  Widget _buildWorkoutTypeSelector() {
    final workoutTypes = getWorkoutTypes(context);

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
                      : [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? (type['gradient'][0] as Color).withOpacity(0.3)
                        : Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.1),
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
                    color: isSelected ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onPrimary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    type['name'],
                    style: GoogleFonts.inter(
                      color: isSelected ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onPrimary,
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
      final workoutTypes = getWorkoutTypes(context);

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
                  color: Theme.of(context).colorScheme.surface,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.1),
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
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _workoutDescriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Describe your workout...',
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
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
  Widget _buildSubmitButton() {
      final workoutTypes = getWorkoutTypes(context);

  
  
    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitWorkout,
        style: ElevatedButton.styleFrom(
          backgroundColor: workoutTypes[_selectedWorkoutType]['gradient'][0],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isSubmitting
            ? CircularProgressIndicator(color: Theme.of(context).colorScheme.surface)
            : Text(
                'Save Workout',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
      ),
    );
  }

// Success snackbar
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

// Error snackbar
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
  // Add this new widget for reflection tab
  Widget _buildReflectionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMoodSelector(),
          const SizedBox(height: 24),
          _buildReflectionPrompts(),
          const SizedBox(height: 24),
          _buildReflectionInput(),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    final moods = [
      {'emoji': '😤', 'label': 'Pumped'},
      {'emoji': '💪', 'label': 'Strong'},
      {'emoji': '😅', 'label': 'Tired'},
      {'emoji': '🤔', 'label': 'Challenged'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.1),
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
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: moods.map((mood) {
              return Column(
                children: [
                  Text(
                    mood['emoji']!,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mood['label']!,
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionPrompts() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _reflectionPrompts.length,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).colorScheme.secondaryFixed, Theme.of(context).colorScheme.tertiary],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                _reflectionPrompts[index],
                style: GoogleFonts.poppins(
                  color: Theme.of(context).colorScheme.surface,
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

  Widget _buildReflectionInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Reflection',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _reflectionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Share your thoughts about today\'s workout...',
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
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
   // Update the _buildContent method to use the new reflection tab


  // Update the submit workout function to include reflection data
  Future<void> _submitWorkout() async {
    final workoutTypes = getWorkoutTypes(context);

    if (user == null || _workoutDescriptionController.text.isEmpty) {
      _showErrorSnackBar('Please add a description of your workout');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Create workout data including reflection
      final workoutData = {
        'outside_workout': {
          // add date and firebase uid 
          'date': today.toString().substring(0, 10),
          'firebase_uid': user!.uid,
          'description': _workoutDescriptionController.text,
          'thoughts': _reflectionController.text,
          'completed': true,
          'type': workoutTypes[_selectedWorkoutType]['name'],
        }
      };

      // Make API call
      final response = await http.put(
        Uri.parse(
            'http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(workoutData),
      );

      if (response.statusCode == 200) {
        setState(() => _completedWorkout = true);
        _showSuccessSnackBar('Workout saved successfully! 💪');
        
        // Auto-switch to reflection tab after successful submission
        if (_reflectionController.text.isEmpty) {
          _tabController.animateTo(1);
        }
      } else {
        _showErrorSnackBar('Failed to save workout');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving workout');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  // Add fetch workout data function
  Future<void> _fetchWorkoutData() async {
    final workoutTypes = getWorkoutTypes(context);

    if (user == null) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final workout = data['outside_workout'];
        
        if (workout != null) {
          setState(() {
            _workoutDescriptionController.text = workout['description'] ?? '';
            _reflectionController.text = workout['thoughts'] ?? '';
            _completedWorkout = workout['completed'] ?? false;
            
            // Set workout type if it exists
            final workoutType = workout['type'];
            if (workoutType != null) {
              _selectedWorkoutType = workoutTypes.indexWhere(
                (type) => type['name'] == workoutType
              );
              if (_selectedWorkoutType == -1) _selectedWorkoutType = 0;
            }
          });
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error loading workout data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildContent(BuildContext context) {
    return TabBarView(
      controller: _tabController, 
      children: [
        _buildWorkoutTab(),
        _buildReflectionTab(),

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
                    Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.9),
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
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
