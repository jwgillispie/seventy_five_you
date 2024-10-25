import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/models/outside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:seventy_five_hard/features/presentation/models/day_model.dart'; // Assuming you have the Day model
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class WorkoutOnePage extends StatefulWidget {
  const WorkoutOnePage({Key? key}) : super(key: key);

  @override
  _WorkoutOnePageState createState() => _WorkoutOnePageState();
}

class _WorkoutOnePageState extends State<WorkoutOnePage> {
  final TextEditingController _workoutDescriptionController = TextEditingController();
  final TextEditingController _reflectionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Day? day; // Day object that contains the outside workout model
  OutsideWorkout? outsideWorkout;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _fetchDayData(); // Fetch existing day data for this user and date
  }

  @override
  void dispose() {
    _workoutDescriptionController.dispose();
    _reflectionController.dispose();
    super.dispose();
  }

  // Fetch the current day's data from the backend
  Future<void> _fetchDayData() async {
    if (user == null) return;

    String formattedDate = today.toString().substring(0, 10);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user!.uid}/$formattedDate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          day = Day.fromJson(json.decode(response.body));
          outsideWorkout = day!.outsideWorkout;
        });
      }
    } catch (e) {
      print("Error fetching day data: $e");
    }
  }

  Future<void> _submitWorkoutDescription() async {
    if (user == null || outsideWorkout == null) return;

    outsideWorkout!.description = _workoutDescriptionController.text;
    final Map<String, dynamic> workoutData = outsideWorkout!.toJson();

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'outside_workout': workoutData}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout description updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update workout.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _submitReflection() async {
    if (user == null || outsideWorkout == null) return;

    outsideWorkout!.thoughts = _reflectionController.text;
    final Map<String, dynamic> workoutData = outsideWorkout!.toJson();

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'outside_workout': workoutData}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reflection updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update reflection.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout 1',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 4,
        shadowColor: theme.colorScheme.primary.withOpacity(0.4),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildWorkoutCard(
                context,
                title: 'Workout',
                controller: _workoutDescriptionController,
                hintText: 'Enter your workout description',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitWorkoutDescription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Submit Workout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              _buildWorkoutCard(
                context,
                title: 'Reflection',
                controller: _reflectionController,
                hintText: 'Enter your thoughts or feelings',
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReflection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Submit Thoughts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: const NavBar(),
    );
  }

  // Helper method to build the styled workout/reflection card
  Widget _buildWorkoutCard(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: theme.hintColor.withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: maxLines,
            ),
          ],
        ),
      ),
    );
  }
}
