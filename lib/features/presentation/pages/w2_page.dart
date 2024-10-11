import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/features/presentation/models/inside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/day_model.dart';

class WorkoutTwoPage extends StatefulWidget {
  const WorkoutTwoPage({Key? key}) : super(key: key);

  @override
  _WorkoutTwoPageState createState() => _WorkoutTwoPageState();
}

class _WorkoutTwoPageState extends State<WorkoutTwoPage> {
  final TextEditingController _workoutDescriptionController = TextEditingController();
  final TextEditingController _reflectionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Day? day; // Day object that contains the inside workout model
  InsideWorkout? insideWorkout;
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
    print("Fetching day data for $formattedDate"); // DEBUG
    try {
      // Fetch the Day object for the current date and user
      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user!.uid}/$formattedDate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the response and set the day object
        setState(() {
          day = Day.fromJson(json.decode(response.body));
          insideWorkout = day!.insideWorkout; // Initialize the insideWorkout object from the day model
        });
        print("Day data fetched successfully: ${response.body}"); // DEBUG
      } else {
        print("Failed to fetch day data: ${response.statusCode}"); // DEBUG
      }
    } catch (e) {
      print("Error fetching day data: $e"); // DEBUG
    }
  }

  // Function to submit workout description and update the backend
  Future<void> _submitWorkoutDescription() async {
    print("Submit Workout Description function called."); // DEBUG
    if (user == null || insideWorkout == null) {
      print("Error: User or inside workout is null."); // DEBUG
      return;
    }

    // Update the inside workout description
    insideWorkout!.description = _workoutDescriptionController.text;

    // Convert the updated inside workout object to JSON format
    final Map<String, dynamic> workoutData = insideWorkout!.toJson();
    print("Workout data after updating description: $workoutData"); // DEBUG

    try {
      // Perform a PUT request to update the inside workout entry in the backend
      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'inside_workout': workoutData}), // Updating only the inside_workout part
      );

      print("Response status code: ${response.statusCode}"); // DEBUG
      print("Response body after call: ${response.body}"); // DEBUG

      if (response.statusCode == 200) {
        print("Workout description updated successfully!"); // DEBUG
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout description updated successfully!')),
        );
      } else {
        print("Failed to update workout. Response body: ${response.body}"); // DEBUG
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update workout.')),
        );
      }
    } catch (e) {
      print("Error occurred while updating workout description: $e"); // DEBUG
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to submit reflection and update the backend
  Future<void> _submitReflection() async {
    print("Submit Reflection function called."); // DEBUG
    if (user == null || insideWorkout == null) {
      print("Error: User or inside workout is null."); // DEBUG
      return;
    }

    // Update the reflection field in the inside workout
    insideWorkout!.thoughts = _reflectionController.text;

    // Convert the updated inside workout object to JSON format
    final Map<String, dynamic> workoutData = insideWorkout!.toJson();
    print("Workout data after updating reflection: $workoutData"); // DEBUG

    try {
      // Perform a PUT request to update the inside workout entry in the backend
      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'inside_workout': workoutData}), // Updating only the inside_workout part
      );

      print("Response status code: ${response.statusCode}"); // DEBUG
      print("Response body after call: ${response.body}"); // DEBUG

      if (response.statusCode == 200) {
        print("Reflection updated successfully!"); // DEBUG
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reflection updated successfully!')),
        );
      } else {
        print("Failed to update reflection. Response body: ${response.body}"); // DEBUG
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update reflection.')),
        );
      }
    } catch (e) {
      print("Error occurred while updating reflection: $e"); // DEBUG
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout 2',
          style: GoogleFonts.lato(),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  children: [
                    Text(
                      'Workout',
                      style: GoogleFonts.lato(fontSize: 20),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: _workoutDescriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your workout description',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitWorkoutDescription, // Submit workout description
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text('Submit Workout'),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  children: [
                    Text(
                      'Reflection',
                      style: GoogleFonts.lato(fontSize: 20),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: _reflectionController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your thoughts or feelings',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReflection, // Submit thoughts/reflection
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text('Submit Thoughts'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
