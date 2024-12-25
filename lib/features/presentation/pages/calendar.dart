import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:seventy_five_hard/features/presentation/models/day_model.dart';
import 'package:seventy_five_hard/themes.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<dynamic>> _events;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Day? day;
  bool isDayEmpty = true;
  bool _isLoading = false;
  Map<String, bool> expandedTasks = {};

  

@override
void initState() {
  super.initState();
  user = _auth.currentUser;
  _events = {};
  _fetchObjectives();
  
  // Initialize all tasks as collapsed
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final tasks = getTasks(context);
    for (var task in tasks) {
      expandedTasks[task['id']] = false;
    }
  });
}

  Future<void> _fetchObjectives() async {
    if (user == null) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost:8000/day/${user!.uid}/${_selectedDay.toString().substring(0, 10)}',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          day = Day.fromJson(json.decode(response.body));
          isDayEmpty = false;
        });
      } else {
        setState(() => isDayEmpty = true);
      }
    } catch (e) {
      _showErrorSnackBar('Error loading data');
    } finally {
      setState(() => _isLoading = false);
    }
  }
List<Map<String, dynamic>> getTasks(BuildContext context) {
  return [
    {
      'id': 'diet',
      'title': 'Diet',
      'icon': Icons.restaurant_menu,
      'color': Theme.of(context).colorScheme.primary,
    },
    {
      'id': 'outside_workout',
      'title': 'Outside Workout',
      'icon': Icons.directions_run,
      'color': Theme.of(context).colorScheme.secondary,
    },
    {
      'id': 'inside_workout',
      'title': 'Inside Workout',
      'icon': Icons.fitness_center,
      'color': Theme.of(context).colorScheme.tertiary,
    },
    {
      'id': 'water',
      'title': 'Water',
      'icon': Icons.water_drop,
      'color': Theme.of(context).colorScheme.secondary,
    },
    {
      'id': 'alcohol',
      'title': 'No Alcohol',
      'icon': Icons.no_drinks,
      'color': const Color(0xFFB23B3B),
    },
    {
      'id': 'pages',
      'title': 'Reading',
      'icon': Icons.book,
      'color': Theme.of(context).colorScheme.primary.withBlue(150),
    },
  ];
}

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.secondaryFixed, Theme.of(context).colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
                    'Daily Progress',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedDay.toString().substring(0, 10),
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.surface,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(20),
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
      child: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2024, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            // Reset expanded states when selecting a new day
            expandedTasks.updateAll((key, value) => false);
          });
          _fetchObjectives();
        },
        headerStyle: HeaderStyle(
          titleTextStyle: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskSection() {
    final tasks = getTasks(context);
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isExpanded = expandedTasks[task['id']] ?? false;
        return _buildExpandableTask(task, isExpanded);
      },
    );
  }

  Widget _buildExpandableTask(Map<String, dynamic> task, bool isExpanded) {
    bool isCompleted = _getTaskCompletionStatus(task['id']);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: task['color'].withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Task Header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  expandedTasks[task['id']] = !isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: task['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        task['icon'],
                        color: task['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        task['title'],
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                            : Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isCompleted ? 'Completed' : 'Incomplete',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isCompleted
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expanded Details
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: task['color'].withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: _buildTaskDetails(task['id']),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDetails(String taskId) {
    switch (taskId) {
      case 'diet':
        return _buildDietDetails();
      case 'outside_workout':
        return _buildWorkoutDetails(true);
      case 'inside_workout':
        return _buildWorkoutDetails(false);
      case 'water':
        return _buildWaterDetails();
      case 'alcohol':
        return _buildAlcoholDetails();
      case 'pages':
        return _buildReadingDetails();
      default:
        return const SizedBox();
    }
  }

  Widget _buildDietDetails() {
    final diet = day?.diet;
    if (diet == null) return const Text('No data available');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMealSection('Breakfast', diet.breakfast ?? []),
        _buildMealSection('Lunch', diet.lunch ?? []),
        _buildMealSection('Dinner', diet.dinner ?? []),
        _buildMealSection('Snacks', diet.snacks ?? []),
      ],
    );
  }

  Widget _buildMealSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 4),
        if (items.isEmpty)
          Text(
            'No items logged',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Text(
                  '• $item',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                ),
              )),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildWorkoutDetails(bool isOutside) {
    final workout = isOutside ? day?.outsideWorkout : day?.insideWorkout;
    if (workout == null) return const Text('No workout logged');

    // Extract description and thoughts with null safety
    final description =
        workout is Map ? workout['description'] as String? : null;
    final thoughts = workout is Map ? workout['thoughts'] as String? : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description ?? 'No description provided',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        const SizedBox(height: 16),
        Text(
          'Thoughts',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          thoughts ?? 'No thoughts recorded',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
      ],
    );
  }

  Widget _buildWaterDetails() {
    final water = day?.water;
    if (water == null) return const Text('No data available');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.confirmation_number, color: Theme.of(context).colorScheme.secondaryFixed),
            const SizedBox(width: 8),
            Text(
              'Bathroom Breaks: ${water.peeCount ?? 0}',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              water.completed ?? false
                  ? Icons.check_circle
                  : Icons.error_outline,
              color: water.completed ?? false
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondaryFixed,
            ),
            const SizedBox(width: 8),
            Text(
              water.completed ?? false
                  ? 'Daily water goal achieved!'
                  : 'Water goal not yet met',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlcoholDetails() {
    final alcohol = day?.alcohol;
    if (alcohol == null) return const Text('No data available');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              alcohol.completed ?? false ? Icons.check_circle : Icons.cancel,
              color: alcohol.completed ?? false
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFFB23B3B),
            ),
            const SizedBox(width: 8),
            Text(
              alcohol.completed ?? false
                  ? 'Successfully avoided alcohol today!'
                  : 'Goal not met today',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (alcohol.difficulty != null) ...[
          Text(
            'Difficulty Level',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: alcohol.difficulty! / 10,
              backgroundColor: Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                alcohol.difficulty! > 7
                    ? const Color(0xFFB23B3B)
                    : alcohol.difficulty! > 4
                        ? Theme.of(context).colorScheme.secondaryFixed
                        : Theme.of(context).colorScheme.primary,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getDifficultyLabel(alcohol.difficulty!),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  String _getDifficultyLabel(int difficulty) {
    if (difficulty <= 3) return 'Easy to maintain';
    if (difficulty <= 6) return 'Moderately challenging';
    if (difficulty <= 8) return 'Very challenging';
    return 'Extremely difficult';
  }

  Widget _buildReadingDetails() {
    final pages = day?.pages;
    if (pages == null) return const Text('No data available');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (pages.bookTitle != null && pages.bookTitle!.isNotEmpty) ...[
          Text(
            'Current Book',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pages.bookTitle!,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Icon(Icons.menu_book, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Pages Read: ${pages.pagesRead ?? 0}/10',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (pages.summary != null && pages.summary!.isNotEmpty) ...[
          Text(
            'Reading Notes',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pages.summary!,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
        ],
      ],
    );
  }

  bool _getTaskCompletionStatus(String taskId) {
    if (day == null) return false;

    switch (taskId) {
      case 'diet':
        return day!.diet?.completed ?? false;
      case 'outside_workout':
        return day!.outsideWorkout?.completed ?? false;
      case 'inside_workout':
        return day!.insideWorkout?.completed ?? false;
      case 'water':
        return day!.water?.completed ?? false;
      case 'alcohol':
        return day!.alcohol?.completed ?? false;
      case 'pages':
        return day!.pages?.completed ?? false;
      default:
        return false;
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFB23B3B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildCalendar()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Text(
                    'Daily Tasks',
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildTaskSection()),
              // Add some padding at the bottom
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
