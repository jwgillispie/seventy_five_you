import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:seventy_five_hard/features/presentation/models/ten_pages_model.dart';
import 'package:seventy_five_hard/features/presentation/models/day_model.dart';

class TenPagesPage extends StatefulWidget {
  const TenPagesPage({Key? key}) : super(key: key);

  @override
  State<TenPagesPage> createState() => _TenPagesPageState();
}

class _TenPagesPageState extends State<TenPagesPage> {
  final TextEditingController _summaryController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Day? day;
  TenPages? tenPages;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _fetchDayData(); // Fetch existing day data for this user and date
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  // Fetch the current day's data from the backend
  Future<void> _fetchDayData() async {
    if (user == null) return;

    String formattedDate = today.toString().substring(0, 10);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user!.uid}/$formattedDate'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},  // Ensure UTF-8
      );

      if (response.statusCode == 200) {
        setState(() {
          day = Day.fromJson(json.decode(response.body));
          tenPages = day!.pages;
        });
      } else {
        print("Failed to fetch day data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching day data: $e");
    }
  }

  // Function to submit the summary and mark the task as completed
  Future<void> _submitTenPages() async {
    if (user == null || tenPages == null) {
      return;
    }

    // Update the summary and mark as completed
    tenPages!.summary = _summaryController.text;
    tenPages!.completed = true;

    // Convert the updated TenPages object to JSON format
    final Map<String, dynamic> tenPagesData = tenPages!.toJson();

    try {
      // Perform a PUT request to update the ten_pages entry in the backend
      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',  // Add charset=utf-8
        },
        body: json.encode({'pages': tenPagesData}), // Updating only the ten_pages part
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ten Pages data updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update Ten Pages.')),
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
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ten Pages'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Summarize what you read in the 10 pages:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _summaryController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts on the pages you read...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                    prefixIcon: Icon(Icons.book, color: Theme.of(context).primaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitTenPages, // Submit summary and update TenPages model
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.2,
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
