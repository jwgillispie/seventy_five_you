import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:seventy_five_hard/features/presentation/models/diet_model.dart';
import 'package:seventy_five_hard/features/presentation/models/day_model.dart'; // Assuming you have the Day model

class DietPage extends StatefulWidget {
  const DietPage({Key? key}) : super(key: key);

  @override
  DietPageState createState() => DietPageState();
}

class DietPageState extends State<DietPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Day? day; // Day object that contains the diet model
  Diet? diet;
  DateTime today = DateTime.now();
  Map<String, List<String>> mealsToday = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
    'Snacks': []
  };

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
      // Fetch the Day object for the current date and user
      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user!.uid}/$formattedDate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the response and set the day object
        setState(() {
          day = Day.fromJson(json.decode(response.body));
          diet = day!.diet; // Initialize the diet object from the day model
        });
        print("Day data fetched successfully: ${response.body}"); // DEBUG
      } else {
        print("Failed to fetch day data: ${response.statusCode}"); // DEBUG
      }
    } catch (e) {
      print("Error fetching day data: $e"); // DEBUG
    }
  }

  // Function to append a meal to the respective meal type and update the backend
  Future<void> submitMeal(String mealType, String newMeal) async {
    print("Submit Meal function called for $mealType with $newMeal"); // DEBUG

    if (user == null || diet == null) {
      print("Error: User or diet is null."); // DEBUG
      return;
    }

    // Append the new meal to the correct meal type
    if (mealType == 'Breakfast') {
      diet!.breakfast = (diet!.breakfast ?? [])..add(newMeal);
    } else if (mealType == 'Lunch') {
      diet!.lunch = (diet!.lunch ?? [])..add(newMeal);
    } else if (mealType == 'Dinner') {
      diet!.dinner = (diet!.dinner ?? [])..add(newMeal);
    } else if (mealType == 'Snacks') {
      diet!.snacks = (diet!.snacks ?? [])..add(newMeal);
    }

    // Convert the updated diet object to JSON format
    final Map<String, dynamic> dietData = diet!.toJson();
    print("Diet data after appending meal: $dietData"); // DEBUG

    try {
      // Perform a PUT request to update the diet entry in the backend using the firebaseUid and date
      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'diet': dietData}), // Updating only the diet part
      );
      print("Response status code: ${response.statusCode}"); // DEBUG
      print("Response body after call: ${response.body}"); // DEBUG


      if (response.statusCode == 200) {
        // Handle successful update
        print("Diet data updated successfully!"); // DEBUG
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diet data updated successfully!')),
        );
      } else {
        // Handle error response
        print("Failed to update diet data. Response body: ${response.body}"); // DEBUG
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update diet data')),
        );
      }
    } catch (e) {
      // Handle connection error
      print("Error occurred while updating diet data: $e"); // DEBUG
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to display the Add Meal dialog
  void _showAddMealDialog(String mealType) async {
    print("Opening Add Meal Dialog for $mealType"); // DEBUG
    TextEditingController mealController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(mealType),
          content: TextField(
            controller: mealController,
            decoration: const InputDecoration(hintText: 'Enter what you ate'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                print("Add Meal Dialog cancelled"); // DEBUG
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add Meal'),
              onPressed: () {
                print("Meal added: ${mealController.text} for $mealType"); // DEBUG
                setState(() {
                  mealsToday[mealType]?.add(mealController.text); // Add locally for display
                });
                Navigator.of(context).pop();

                // Call `submitMeal` after adding the meal to update the backend
                submitMeal(mealType, mealController.text);
              },
            ),
          ],
        );
      },
    );
  }

  // Widget to display meal buttons
  Widget _mealTypeButton(String mealType) {
    print("Creating button for $mealType"); // DEBUG
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(mealType,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        onTap: () => _showAddMealDialog(mealType),
      ),
    );
  }

  // Widget to display the list of meals for each type
  Widget _mealList(String mealType) {
    print("Displaying meal list for $mealType"); // DEBUG
    return Column(
      children: mealsToday[mealType]!.map((meal) {
        print("Meal: $meal for $mealType"); // DEBUG
        return ListTile(
          title: Text(meal),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building DietPage UI"); // DEBUG
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Tracker'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: mealsToday.keys.length,
          itemBuilder: (context, index) {
            String mealType = mealsToday.keys.elementAt(index);
            return Column(
              children: [
                _mealTypeButton(mealType),
                _mealList(mealType),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const NavBar(),
        ],
      ),
    );
  }
}
