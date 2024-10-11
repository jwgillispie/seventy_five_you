import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:seventy_five_hard/features/presentation/models/water_model.dart';
import 'package:seventy_five_hard/features/presentation/models/day_model.dart';

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  @override
  _WaterPageState createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  double _remainingWaterOunces = 128.0;
  int _bathroomCounter = 0;
  bool _showMotivation = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Day? day; // Day object that contains the Water model
  Water? water; // Water model object
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _fetchDayData(); // Fetch existing day data for this user and date
  }

  // Fetch the current day's data from the backend
  Future<void> _fetchDayData() async {
    if (user == null) return;

    String formattedDate = today.toString().substring(0, 10);
    print("Fetching day data for $formattedDate"); // DEBUG
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user!.uid}/$formattedDate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          day = Day.fromJson(json.decode(response.body));
          water = day!.water; // Initialize the water object from the day model
          _bathroomCounter = water?.peeCount ?? 0;
          _remainingWaterOunces = water?.completed == true ? 0 : 128; // Set water level based on completed status
        });
        print("Day data fetched successfully: ${response.body}"); // DEBUG
      } else {
        print("Failed to fetch day data: ${response.statusCode}"); // DEBUG
      }
    } catch (e) {
      print("Error fetching day data: $e"); // DEBUG
    }
  }

  // Update water and send data to backend
  Future<void> _updateWaterData() async {
    if (user == null || water == null) return;

    // Mark the water task as completed if the remaining water is 0
    water!.completed = _remainingWaterOunces == 0;
    water!.peeCount = _bathroomCounter;

    // Convert water data to JSON
    final Map<String, dynamic> waterData = water!.toJson();
    print("Water data to send to backend: $waterData"); // DEBUG

    try {
      // Send PUT request to update the water data in the backend
      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'water': waterData}),
      );

      print("Response status code: ${response.statusCode}"); // DEBUG
      print("Response body after update: ${response.body}"); // DEBUG

      if (response.statusCode == 200) {
        print("Water data updated successfully!"); // DEBUG
      } else {
        print("Failed to update water data: ${response.body}"); // DEBUG
      }
    } catch (e) {
      print("Error updating water data: $e"); // DEBUG
    }
  }

  void _updateWaterLevel(double newValue) {
    setState(() {
      _remainingWaterOunces = newValue;
      _showMotivation = newValue == 0;
    });
    _updateWaterData(); // Update backend with new water data
  }

  void _incrementPeeCount() {
    setState(() => _bathroomCounter++);
    _updateWaterData(); // Update backend with new pee count
  }

  void _decrementPeeCount() {
    if (_bathroomCounter > 0) {
      setState(() => _bathroomCounter--);
      _updateWaterData(); // Update backend with new pee count
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydrating'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Water Level Slider
                RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    value: _remainingWaterOunces,
                    min: 0,
                    max: 128,
                    divisions: 128,
                    onChanged: _updateWaterLevel,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 20),
                // Water Gallon Representation
                Container(
                  height: 200,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: _remainingWaterOunces / 128.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (_showMotivation)
              Text(
                'Great job on staying hydrated!',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18),
              ),
            const SizedBox(height: 20),
            // Pee Count
            Text(
              'Pee Count: $_bathroomCounter',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24, color: Theme.of(context).colorScheme.primary),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _decrementPeeCount,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _incrementPeeCount,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
