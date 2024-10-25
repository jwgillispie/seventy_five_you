import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/presentation/models/alcohol_model.dart';
import 'package:seventy_five_hard/features/presentation/models/day_model.dart';
import 'package:seventy_five_hard/features/presentation/models/diet_model.dart';
import 'package:seventy_five_hard/features/presentation/models/inside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/outside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/ten_pages_model.dart';
import 'package:seventy_five_hard/features/presentation/models/water_model.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:seventy_five_hard/themes.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<dynamic>> _events;
  DateTime _selectedDay = DateTime.now(); // Track the selected day
  DateTime _focusedDay = DateTime.now(); // Track the focused day
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Water? waterModel;
  Diet? dietModel;
  InsideWorkout? insideWorkoutModel;
  OutsideWorkout? outsideWorkoutModel;
  TenPages? tenPagesModel;
  Alcohol? alcoholModel;
  User? user;
  bool isDayEmpty = false; // Flag for empty day

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _events = {};
    _fetchObjectives(); // Fetch objectives when the calendar is initialized
  }

  // Fetch the objectives for the selected day
  Future<void> _fetchObjectives() async {
    String formattedDate = "${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day}";
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8000/day/${user?.uid}/${_selectedDay.toString().substring(0, 10)}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          Day day = Day.fromJson(data);
          waterModel = day.water;
          dietModel = day.diet;
          insideWorkoutModel = day.insideWorkout;
          outsideWorkoutModel = day.outsideWorkout;
          tenPagesModel = day.pages;
          alcoholModel = day.alcohol;
          isDayEmpty = false; // Reset empty flag if objectives are found
        });
      } else if (response.statusCode == 404) {
        // Handle 404 - No data for this day
        setState(() {
          _clearObjectives();
          isDayEmpty = true; // Set the empty flag if no data is found
        });
      } else {
        print('Failed to fetch objectives: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching objectives: $e");
      setState(() {
        isDayEmpty = true; // Mark as empty if error occurs
      });
    }
  }

  // Clear the objectives when no data is found
  void _clearObjectives() {
    waterModel = null;
    dietModel = null;
    insideWorkoutModel = null;
    outsideWorkoutModel = null;
    tenPagesModel = null;
    alcoholModel = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: theme.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor.withOpacity(0.2),
              theme.colorScheme.secondary.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar Widget
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2023, 1, 1),
                lastDay: DateTime.utc(2024, 12, 31),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                calendarFormat: CalendarFormat.month,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _fetchObjectives(); // Fetch the objectives for the selected day
                },
                eventLoader: (day) => _events[day] ?? [],
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withOpacity(0.5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.secondary.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  selectedDecoration: BoxDecoration(
                    color: SFColors.navyBlue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Logged Objectives for ${_selectedDay.toString().substring(0, 10)}',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: SFColors.navyBlue,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Check if the day is empty and display the appropriate screen
              isDayEmpty
                  ? _buildEmptyDayScreen(context)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildObjectivesDisplay(context),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  // Widget to show an empty day screen with a message
  Widget _buildEmptyDayScreen(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 100,
              color: theme.primaryColor.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              'No objectives logged for this day',
              style: theme.textTheme.displayMedium?.copyWith(
                color: SFColors.navyBlue,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'It looks like you haven\'t logged any activities for ${_selectedDay.toString().substring(0, 10)}. Select another day or start logging your activities!',
              style: theme.textTheme.displayMedium?.copyWith(
                color: SFColors.navyBlue.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display logged objectives when data is available
  Widget _buildObjectivesDisplay(BuildContext context) {
    final theme = Theme.of(context);

    final sectionTitleStyle = theme.textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.secondary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (waterModel != null)
          _buildObjectiveCard(
            title: 'Water Intake',
            icon: Icons.water_drop,
            content: [
              _buildObjectiveContent(
                icon: Icons.bathroom_outlined,
                label: 'Pee Count: ${waterModel!.peeCount}',
                success: waterModel!.peeCount! > 5,
              ),
            ],
            sectionTitleStyle: sectionTitleStyle,
            theme: theme,
          ),
        if (dietModel != null)
          _buildObjectiveCard(
            title: 'Diet',
            icon: Icons.restaurant_menu,
            content: [
              _buildObjectiveContent(
                icon: Icons.breakfast_dining,
                label: 'Breakfast: ${dietModel!.breakfast?.join(", ") ?? "N/A"}',
              ),
              _buildObjectiveContent(
                icon: Icons.lunch_dining,
                label: 'Lunch: ${dietModel!.lunch?.join(", ") ?? "N/A"}',
              ),
              _buildObjectiveContent(
                icon: Icons.dinner_dining,
                label: 'Dinner: ${dietModel!.dinner?.join(", ") ?? "N/A"}',
              ),
              _buildObjectiveContent(
                icon: Icons.fastfood,
                label: 'Snacks: ${dietModel!.snacks?.join(", ") ?? "N/A"}',
              ),
            ],
            sectionTitleStyle: sectionTitleStyle,
            theme: theme,
          ),
        if (insideWorkoutModel != null)
          _buildObjectiveCard(
            title: 'Inside Workout',
            icon: Icons.fitness_center,
            content: [
              _buildObjectiveContent(
                icon: Icons.run_circle,
                label: 'Description: ${insideWorkoutModel!.description}',
                success: insideWorkoutModel!.description!.isNotEmpty,
              ),
              _buildObjectiveContent(
                icon: Icons.lightbulb,
                label: 'Thoughts: ${insideWorkoutModel!.thoughts}',
              ),
            ],
            sectionTitleStyle: sectionTitleStyle,
            theme: theme,
          ),
        if (outsideWorkoutModel != null)
          _buildObjectiveCard(
            title: 'Outside Workout',
            icon: Icons.directions_run,
            content: [
              _buildObjectiveContent(
                icon: Icons.nature_people,
                label: 'Description: ${outsideWorkoutModel!.description}',
                success: outsideWorkoutModel!.description!.isNotEmpty,
              ),
              _buildObjectiveContent(
                icon: Icons.lightbulb_outline,
                label: 'Thoughts: ${outsideWorkoutModel!.thoughts}',
              ),
            ],
            sectionTitleStyle: sectionTitleStyle,
            theme: theme,
          ),
        if (tenPagesModel != null)
          _buildObjectiveCard(
            title: 'Ten Pages',
            icon: Icons.book,
            content: [
              _buildObjectiveContent(
                icon: Icons.menu_book,
                label: 'Completed: ${tenPagesModel!.completed == true ? "Yes" : "No"}',
                success: tenPagesModel!.completed == true,
              ),
              if (tenPagesModel!.summary != null && tenPagesModel!.summary!.isNotEmpty)
                _buildObjectiveContent(
                  icon: Icons.notes,
                  label: 'Summary: ${tenPagesModel!.summary}',
                ),
            ],
            sectionTitleStyle: sectionTitleStyle,
            theme: theme,
          ),
        if (alcoholModel != null)
          _buildObjectiveCard(
            title: 'Alcohol Consumption',
            icon: Icons.no_drinks,
            content: [
              _buildObjectiveContent(
                icon: Icons.no_drinks,
                label: 'Consumed: ${alcoholModel!.completed == true ? "No" : "Yes"}',
                success: alcoholModel!.completed == true,
              ),
            ],
            sectionTitleStyle: sectionTitleStyle,
            theme: theme,
          ),
        if (waterModel == null &&
            dietModel == null &&
            insideWorkoutModel == null &&
            outsideWorkoutModel == null &&
            tenPagesModel == null &&
            alcoholModel == null)
          const Text('No data available for this day.'),
      ],
    );
  }

  // Widget to build an objective card
  Widget _buildObjectiveCard({
    required String title,
    required IconData icon,
    required List<Widget> content,
    required TextStyle? sectionTitleStyle,
    required ThemeData theme,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shadowColor: theme.primaryColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: SFColors.navyBlue),
                const SizedBox(width: 10),
                Text(title, style: sectionTitleStyle?.copyWith(color: SFColors.navyBlue)),
              ],
            ),
            const SizedBox(height: 5),
            // add in a divider line 
            const Divider(color: SFColors.navyBlue,),
            ...content,
          ],
        ),
      ),
    );
  }

  // Widget to build objective content with icons and text
  Widget _buildObjectiveContent({
    required IconData icon,
    required String label,
    bool success = true,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: success ? SFColors.navyBlue : Colors.red),
          const SizedBox(width: 10),
          Text(
            label,
            style: theme.textTheme.displaySmall?.copyWith(
              color: success ? SFColors.navyBlue : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
