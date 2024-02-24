import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/presentation/bloc_pattern/users/bloc/user_bloc.dart';
import 'dart:convert';

import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:seventy_five_hard/themes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String email = '';
  String username = '';
  final UserBloc userBloc = UserBloc();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      userBloc.add(FetchUserName(user!.uid));
    }
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      if (user != null) {
        // Fetch user data from the server
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8000/user/${user?.uid}'),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            email = user!.email ?? '';
            username = data['display_name'] ?? '';
          });
        } else {
          setState(() {
            username = 'Error retrieving username';
          });
        }
      } else {
        setState(() {
          email = 'User not authenticated';
          username = 'User not authenticated';
        });
      }
    } catch (e) {
      setState(() {
        username = 'Error retrieving username';
      });
    }
  }

  Future<void> editProfile(String newUsername) async {
    try {
      // Construct the request body with the updated username
      Map<String, dynamic> userData = {
        'display_name': newUsername,
      };

      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/user/${user?.uid}'),
        body: jsonEncode(userData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Profile updated successfully
        setState(() {
          username = newUsername;
        });
        print('Profile updated successfully');
      } else {
        // Error updating profile
        print('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      // Error handling
      print('Error updating profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'User Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Email: ${user?.email}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            BlocConsumer<UserBloc, UserState>(
              bloc: userBloc,
              listener: (context, state) {
                if (state is UserError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return Text(
                  state is UserLoaded
                      ? 'Username: ${state.username}'
                      : 'Username: $username',
                  
                  style: Theme.of(context).textTheme.bodyLarge,
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Show dialog to edit profile
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController _usernameController =
                        TextEditingController();
                    _usernameController.text = username;
                    return AlertDialog(
                      title: const Text('Edit Profile'),
                      content: TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Enter New Username',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            editProfile(_usernameController.text);
                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut(); // Sign out the user
                Navigator.pushReplacementNamed(context, "/login");
                Fluttertoast.showToast(msg: "User has been signed out");
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
