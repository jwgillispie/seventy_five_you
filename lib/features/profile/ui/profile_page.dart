import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/auth/presentation/pages/login_page.dart';
import 'package:seventy_five_hard/features/profile/ui/reminder_section.dart';
import 'package:seventy_five_hard/features/profile/ui/theme_selector.dart';
import 'package:seventy_five_hard/themes.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _editMode = false;
  List<String> _reminders = [];
  User? _user;
  String _email = '';
  String _username = '';
  bool _isLoading = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    try {
      _user = _auth.currentUser;
      if (_user != null) {
        final response = await http
            .get(Uri.parse('http://localhost:8000/user/${_user!.uid}'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _email = _user!.email ?? '';
            _username = data['display_name'] ?? '';
          });
        } else {
          Fluttertoast.showToast(msg: 'Error retrieving user data');
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error retrieving user data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _editProfile(String newUsername) async {
    setState(() => _isSubmitting = true);
    try {
      if (_user != null) {
        final response = await http.put(
          Uri.parse('http://localhost:8000/user/${_user!.uid}'),
          body: jsonEncode({'display_name': newUsername}),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          setState(() => _username = newUsername);
          Fluttertoast.showToast(msg: 'Profile updated successfully');
        } else {
          Fluttertoast.showToast(msg: 'Failed to update profile');
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to update profile');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _signOut() {
    _auth.signOut();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginPage(),
      ),
      (_) => false,
    );
    Fluttertoast.showToast(msg: 'User has been signed out');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    Theme.of(context)
                        .colorScheme
                        .secondaryFixed
                        .withOpacity(0.9),
                    Theme.of(context).colorScheme.tertiary,
                  ]
                : [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.background,
                  ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? _buildLoadingState()
              : Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildProfileCard(),
                            const SizedBox(height: 24),
                            _buildSettingsCard(),
                            const SizedBox(height: 24),
                            _buildDangerZoneCard(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildThemeSection() {
    return const ThemeSelector();
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.05),
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.secondaryFixed),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading your profile...',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.secondaryFixed,
                fontSize: 16,
              ),
            ),
          ],
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
            color:
                Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '75 Hard Warrior',
                    style: GoogleFonts.inter(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              _buildProfileImage(),
            ],
          ),
          const SizedBox(height: 20),
          _buildStats(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface.withOpacity(0.2),
            Theme.of(context).colorScheme.surface.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.surface,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Days', '45/75', Icons.calendar_today),
        _buildStatItem('Streak', '7 days', Icons.local_fire_department),
        _buildStatItem('Status', 'Active', Icons.verified),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.surface, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User Info',
                style: GoogleFonts.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondaryFixed,
                ),
              ),
              IconButton(
                icon: Icon(
                  _editMode ? Icons.close : Icons.edit,
                  color: Theme.of(context).colorScheme.secondaryFixed,
                ),
                onPressed: () => setState(() => _editMode = !_editMode),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.secondaryFixed),
            initialValue: _username,
            enabled: _editMode,
            decoration: _buildInputDecoration('Username', Icons.person),
            onChanged: (value) => setState(() => _username = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.secondaryFixed),
            initialValue: _email,
            enabled: false,
            decoration: _buildInputDecoration('Email', Icons.email),
          ),
          _buildThemeSection(),
          const SizedBox(height: 20),
ReminderSection(
  userId: _user?.uid ?? '',
  initialReminders: _reminders,
  onRemindersUpdated: (updatedReminders) {
    setState(() => _reminders = updatedReminders);
  },
),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    if (!_editMode) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondaryFixed,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isSubmitting ? null : () => _editProfile(_username),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryFixed,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: _isSubmitting
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.surface)
                : Text(
                    'Save Changes',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.surface),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondaryFixed,
            const Color(0xFFB23B3B), // Keep error color for danger zone
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger Zone',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _signOut,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: const Color(0xFFB23B3B),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon:
          Icon(icon, color: Theme.of(context).colorScheme.secondaryFixed),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.secondaryFixed),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color:
                Theme.of(context).colorScheme.secondaryFixed.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondaryFixed, width: 2),
      ),
    );
  }
}
