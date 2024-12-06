import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/presentation/login/ui/login_page.dart';
import 'package:seventy_five_hard/themes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
        final response = await http.get(Uri.parse('http://localhost:8000/user/${_user!.uid}'));
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
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: SFColors.primary,
      ),
      body: _isLoading
          ? _buildLoadingState()
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 24.0),
                  _buildAboutSection(),
                  const SizedBox(height: 24.0),
                  _buildSettingsSection(),
                  const SizedBox(height: 24.0),
                  _buildDangerZone(),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(SFColors.primary),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Loading your profile...',
            style: TextStyle(
              color: SFColors.primary,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          backgroundColor: SFColors.primary.withOpacity(0.1),
          child: Icon(
            Icons.person,
            color: SFColors.primary,
            size: 32.0,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _username,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                _email,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Me',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nisl eget ultricies tincidunt, nisl nisl aliquam nisl, eget aliquam nisl nisl eget nisl.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          initialValue: _username,
          onChanged: (value) => setState(() => _username = value),
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          initialValue: _email,
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : () => _editProfile(_username),
            style: ElevatedButton.styleFrom(
              backgroundColor: SFColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                : const Text('Save Changes'),
          ),
        ),
      ],
    );
  }

  Widget _buildDangerZone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Danger Zone',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: _signOut,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}