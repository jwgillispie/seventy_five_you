import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seventy_five_hard/features/presentation/models/alcohol_model.dart';
import 'package:seventy_five_hard/features/presentation/models/day_model.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';

class AlcoholPage extends StatefulWidget {
  const AlcoholPage({Key? key}) : super(key: key);

  @override
  State<AlcoholPage> createState() => _AlcoholPageState();
}

class _AlcoholPageState extends State<AlcoholPage> {
  double _rating = 5.0; // Slider value
  bool _avoidedAlcohol = false; // Switch value
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Alcohol? alcohol; // Alcohol model object
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _fetchAlcoholData(); // Fetch alcohol data when the page is loaded
  }

  // Fetch the alcohol data from the backend
  Future<void> _fetchAlcoholData() async {
    if (user == null) return;

    String formattedDate = today.toString().substring(0, 10);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user!.uid}/$formattedDate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Day day = Day.fromJson(json.decode(response.body));
        setState(() {
          alcohol = day.alcohol;
          // Set the switch value based on whether alcohol was avoided
          _avoidedAlcohol = alcohol?.completed ?? false;
          _rating =
              alcohol?.difficulty?.toDouble() ?? 5.0; // Default difficulty
        });
      } else {
        print("Failed to fetch alcohol data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching alcohol data: $e");
    }
  }

  // Update alcohol data in the backend
  Future<void> _updateAlcoholData() async {
    if (user == null || alcohol == null) return;

    // Update alcohol model
    alcohol!.completed = _avoidedAlcohol; // Set completed based on switch value
    alcohol!.difficulty = _rating.toInt(); // Update difficulty

    final Map<String, dynamic> alcoholData = alcohol!.toJson();
    try {
      final response = await http.put(
        Uri.parse(
            'http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'alcohol': alcoholData}),
      );

      if (response.statusCode == 200) {
        print("Alcohol data updated successfully!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alcohol data updated successfully!')),
        );
      } else {
        print("Failed to update alcohol data: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update alcohol data.')),
        );
      }
    } catch (e) {
      print("Error updating alcohol data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alcohol',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'How hard was it to avoid alcohol today?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Slider(
                    value: _rating,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (value) {
                      setState(() {
                        _rating = value;
                      });
                      _updateAlcoholData(); // Update backend when slider changes
                    },
                    label:
                        '${_rating.toInt()} : ${ratingToDifficulty(_rating)}',
                  ),
                  SwitchListTile(
                    title: const Text('Did you avoid alcohol today?'),
                    value: _avoidedAlcohol,
                    onChanged: (bool value) {
                      setState(() {
                        _avoidedAlcohol = value;
                      });
                      _updateAlcoholData(); // Update backend when switch changes
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  // Convert rating to difficulty label
  String ratingToDifficulty(double rating) {
    if (rating < 3) {
      return 'Easy';
    } else if (rating < 7 && rating >= 3) {
      return 'Moderate';
    } else if (rating >= 7 && rating < 10) {
      return 'Hard';
    } else {
      return 'Impossible';
    }
  }
}
