import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:seventy_five_hard/features/presentation/models/diet_model.dart';
import 'package:seventy_five_hard/features/presentation/models/day_model.dart';
import 'package:seventy_five_hard/themes.dart'; // Assuming you have the Day model

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
          if (diet != null) {
            mealsToday['Breakfast'] = diet!.breakfast ?? [];
            mealsToday['Lunch'] = diet!.lunch ?? [];
            mealsToday['Dinner'] = diet!.dinner ?? [];
            mealsToday['Snacks'] = diet!.snacks ?? [];
          }
        });
      } else {
        print("Failed to fetch day data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching day data: $e");
    }
  }

  // Function to append a meal to the respective meal type and update the backend
  Future<void> submitMeal(String mealType, String newMeal) async {
    if (user == null || diet == null) {
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

    try {
      // Perform a PUT request to update the diet entry in the backend using the firebaseUid and date
      final response = await http.put(
        Uri.parse(
            'http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'diet': dietData}), // Updating only the diet part
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diet data updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update diet data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to display the Add Meal dialog
  void _showAddMealDialog(String mealType) async {
    TextEditingController mealController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(mealType,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold)),
          content: TextField(
            controller: mealController,
            decoration: const InputDecoration(hintText: 'Enter what you ate'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add Meal'),
              style:
                  ElevatedButton.styleFrom(foregroundColor: SFColors.primary),
              onPressed: () {
                setState(() {
                  mealsToday[mealType]
                      ?.add(mealController.text); // Add locally for display
                });
                Navigator.of(context).pop();
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showAddMealDialog(mealType),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(10),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme.colorScheme.surface,
            border:
                Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
          ),
          child: ListTile(
            title: Center(
              child: Text(
                mealType,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget to display the list of meals for each type
  Widget _mealList(String mealType) {
    return Column(
      children: mealsToday[mealType]!.map((meal) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: 3,
          child: ListTile(
            leading:
                Icon(Icons.fastfood, color: Theme.of(context).primaryColor),
            title: Text(
              meal,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Tracker'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/pineapple.jpg'),
              fit: BoxFit
                  .cover, // This makes the image cover the entire background
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: ListView.builder(
              itemCount: mealsToday.keys.length,
              itemBuilder: (context, index) {
                String mealType = mealsToday.keys.elementAt(index);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _mealTypeButton(mealType),
                    const SizedBox(height: 10),
                    _mealList(mealType),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
