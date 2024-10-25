import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200) {
        setState(() {
          day = Day.fromJson(json.decode(response.body));
          tenPages = day!.pages;
          _summaryController.text = tenPages?.summary ?? "";
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
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: json.encode({'pages': tenPagesData}),
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ten Pages',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Summarize what you read in the 10 pages:',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildSummaryCard(context),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTenPages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  // Helper method to build the styled summary card
  Widget _buildSummaryCard(BuildContext context) {
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
        child: TextFormField(
          controller: _summaryController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Share your thoughts on the pages you read...',
            hintStyle: TextStyle(color: theme.hintColor.withOpacity(0.7)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
