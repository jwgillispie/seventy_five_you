import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/themes.dart';

class UserMetricsPage extends StatefulWidget {
  const UserMetricsPage({Key? key}) : super(key: key);

  @override
  _UserMetricsPageState createState() => _UserMetricsPageState();
}

class _UserMetricsPageState extends State<UserMetricsPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isMetric = true;
  bool _isLoading = false;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _messageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submitProfileData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final profileData = {
        'height': _getHeightInMetric(),
        'weight': _getWeightInMetric(),
        'future_message': _messageController.text,
      };

      final response = await http.put(
        Uri.parse('http://localhost:8000/user/${user!.uid}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(profileData),
      );

      if (response.statusCode == 200) {
        // Changed from '/home' to '/reminders_setup'
        Navigator.pushReplacementNamed(context, '/reminders_setup');
      } else {
        _showErrorSnackBar('Failed to save profile data');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving profile data');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  double _getHeightInMetric() {
    final heightValue = double.tryParse(_heightController.text) ?? 0;
    return _isMetric ? heightValue : heightValue * 2.54; // Convert inches to cm
  }

  double _getWeightInMetric() {
    final weightValue = double.tryParse(_weightController.text) ?? 0;
    return _isMetric
        ? weightValue
        : weightValue * 0.453592; // Convert lbs to kg
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(Icons.error_outline,
              color: Theme.of(context).colorScheme.surface),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: const Color(0xFFB23B3B),
      behavior: SnackBarBehavior.floating,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildMetricToggle(),
                    const SizedBox(height: 24),
                    _buildMeasurementsCard(),
                    const SizedBox(height: 24),
                    _buildMessageCard(),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primaryFixed.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complete Your Profile',
            style: GoogleFonts.orbitron(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Let\'s personalize your journey',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primaryFixed.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMetric = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: _isMetric
                      ? LinearGradient(colors: [
                          Theme.of(context).colorScheme.primaryFixed,
                          Theme.of(context).colorScheme.tertiary
                        ])
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Metric',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isMetric
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.secondaryFixed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMetric = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: !_isMetric
                      ? LinearGradient(colors: [
                          Theme.of(context).colorScheme.primaryFixed,
                          Theme.of(context).colorScheme.tertiary
                        ])
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Imperial',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_isMetric
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.secondaryFixed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
              color: Theme.of(context).colorScheme.primaryFixed,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: _isMetric ? 'Height (cm)' : 'Height (inches)',
              prefixIcon: Icon(Icons.height,
                  color: Theme.of(context).colorScheme.primaryFixed),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your height';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: _isMetric ? 'Weight (kg)' : 'Weight (lbs)',
              prefixIcon: Icon(Icons.monitor_weight,
                  color: Theme.of(context).colorScheme.primaryFixed),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your weight';
              }
              return null;
            },
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
              color: Theme.of(context).colorScheme.primaryFixed,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Write a message that you\'ll see in 75 days',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondaryFixed,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Dear future me...',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please write a message';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
                await _submitProfileData();
                if (mounted && !_isLoading) {
                  Navigator.pushReplacementNamed(context, '/reminders_setup');
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isLoading
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.surface)
            : Text(
                'Start Your Journey',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
      ),
    );
  }
}
