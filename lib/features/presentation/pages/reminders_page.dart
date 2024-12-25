import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/features/presentation/models/post_model.dart';
import 'package:seventy_five_hard/themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RemindersSetupPage extends StatefulWidget {
  const RemindersSetupPage({Key? key}) : super(key: key);

  @override
  _RemindersSetupPageState createState() => _RemindersSetupPageState();
}

class _RemindersSetupPageState extends State<RemindersSetupPage> {
  final TextEditingController _reminderController = TextEditingController();
  final List<String> _reminders = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _saveReminders() async {
    if (_reminders.isEmpty) {
      _showErrorSnackBar('Please add at least one motivational message');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user found');

      final response = await http.put(
        Uri.parse('http://localhost:8000/user/${user.uid}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'reminders': _reminders,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/profile-setup');
      } else {
        _showErrorSnackBar('Failed to save reminders');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving reminders');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addReminder() {
    if (_reminderController.text.isEmpty) return;

    setState(() {
      _reminders.add(_reminderController.text);
      _reminderController.clear();
    });
  }

  void _removeReminder(int index) {
    setState(() => _reminders.removeAt(index));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xFFB23B3B),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputSection(),
                      const SizedBox(height: 24),
                      _buildRemindersList(),
                      const SizedBox(height: 24),
                      _buildSuggestions(),
                    ],
                  ),
                ),
              ),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondaryFixed,
            Theme.of(context).colorScheme.tertiary
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primaryFixed.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Daily Motivation', // Changed from 'Set Your Reminders'
            style: GoogleFonts.orbitron(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set messages to keep you motivated', // Changed from notifications text
            style: GoogleFonts.inter(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primaryFixed.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _reminderController,
            decoration: InputDecoration(
              hintText: 'Enter a motivational message...', // Updated hint text
              suffixIcon: IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: _addReminder,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onFieldSubmitted: (_) => _addReminder(),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
// Update the reminders list title:
        Text(
          'Your Motivational Messages', // Changed from 'Your Reminders'
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _reminders.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryFixed
                        .withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(Icons.favorite, // Changed from alarm icon
                    color: Theme.of(context).colorScheme.tertiary),
                title: Text(_reminders[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _removeReminder(index),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSuggestions() {
    final suggestions = [
      'Give up and youre a fucking worthless shit! 💪',
      'Drink your fucking ACQUA bitch! 💧',
      'Just go outside you miserable blob ! 🏃‍♂️',
      'Try not to pass out reading today you dumb! 📚',
      'Take your progress photo ! 📸',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested Messages', // Changed from 'Suggested Reminders'
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions
              .map((suggestion) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _reminders.add(suggestion);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      child: Text(suggestion),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveReminders,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('Continue'),
      ),
    );
  }
}

// profile_setup_page.dart
class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({Key? key}) : super(key: key);

  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _saveProfile() async {
    if (_heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _messageController.text.isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user found');

      final response = await http.put(
        Uri.parse('http://localhost:8000/user/${user.uid}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'height': int.parse(_heightController.text),
          'weight': int.parse(_weightController.text),
          'future_message': _messageController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorSnackBar('Failed to save profile');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving profile');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xFFB23B3B),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildMeasurementsCard(),
                      const SizedBox(height: 24),
                      _buildMessageCard(),
                    ],
                  ),
                ),
              ),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryFixed,
            Theme.of(context).colorScheme.tertiary
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primaryFixed.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Set Up Your Profile',
            style: GoogleFonts.orbitron(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your transformation journey',
            style: GoogleFonts.inter(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primaryFixed.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Measurements',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primaryFixed.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Message to Future You',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Write a message to yourself that you\'ll read in 75 days',
            style: GoogleFonts.inter(
              color: Theme.of(context).colorScheme.secondaryFixed,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Dear future me...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyanAccent,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                selectionColor: Colors.amber,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
