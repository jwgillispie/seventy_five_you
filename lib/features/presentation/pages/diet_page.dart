
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';

import 'package:flutter/material.dart';

class DietPage extends StatefulWidget {
  const DietPage({Key? key}) : super(key: key);

  @override
  DietPageState createState() => DietPageState();
}

class DietPageState extends State<DietPage> {
  Map<String, List<String>> mealsToday = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
    'Snacks': []
  };

  void _showAddMealDialog(String mealType) async {
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
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add Meal'),
              onPressed: () {
                setState(() {
                  mealsToday[mealType]?.add(mealController.text);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _mealTypeButton(String mealType) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(mealType,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        onTap: () => _showAddMealDialog(mealType),
      ),
    );
  }

  Widget _mealList(String mealType) {
    return Column(
      children: mealsToday[mealType]!
          .map((meal) => ListTile(
                title: Text(meal),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: const NavBar(),
    );
  }
}
