import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/presentation/models/water_model.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<dynamic>> _events;
  late DateTime _selectedDay;
  final List<String> _objectives = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Water? waterModel;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _selectedDay = DateTime.now();
    _events = {};
    _fetchObjectives(); // Fetch objectives when widget initializes
  }

  // Function to fetch objectives using HTTP GET request
  Future<void> _fetchObjectives() async {
    String formattedDate =
        "${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day}";
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8000/day/${user?.uid}/${_selectedDay.toString().substring(0, 10)}'), // Replace with your backend URL and Firebase UID
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Clear existing objectives
          _objectives.clear();
          // Add each field to the objectives list
          waterModel = Water.fromJson(data);

          _objectives.addAll([
            'Date: ${data['date']}',
            'Water Intake: ${data['water']}',
            'Alcohol Consumption: ${data['alcohol']}',
            'Pages Read: ${data['pages']}',
            // Add more fields if needed
          ]);
        });
      } else {
        print('Failed to fetch objectives: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching objectives: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              focusedDay: _selectedDay,
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2024, 12, 31),
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _fetchObjectives(); // Fetch objectives when a new day is selected
                });
              },
              eventLoader: (day) => _events[day] ?? [],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Logged Objectives for ${_selectedDay.toString().substring(0, 10)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Check if waterModel is initialized before accessing its properties
                  if (waterModel != null) ...[
                    Text('Date: ${waterModel!.date}'),
                    Text('Pee Count: ${waterModel!.peeCount}')
                  ] else ...[
                    const Text('No data available for this day.'),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
