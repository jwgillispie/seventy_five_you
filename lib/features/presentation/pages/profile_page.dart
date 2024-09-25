import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:seventy_five_hard/features/presentation/users/bloc/user_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String email = '';
  String username = '';
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    userBloc = BlocProvider.of<UserBloc>(context);
    if (user != null) {
      userBloc.add(FetchUserName(user!.uid));
      fetchUserData();
    }
  }

  Future<void> fetchUserData() async {
    if (user == null) return;

    final response = await http.get(Uri.parse('http://localhost:8000/user/${user!.uid}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        email = user!.email ?? '';
        username = data['display_name'] ?? '';
      });
    } else {
      Fluttertoast.showToast(msg: 'Error retrieving user data');
    }
  }

  Future<void> editProfile(String newUsername) async {
    if (user == null) return;

    final response = await http.put(
      Uri.parse('http://localhost:8000/user/${user!.uid}'),
      body: jsonEncode({'display_name': newUsername}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        username = newUsername;
      });
      Fluttertoast.showToast(msg: 'Profile updated successfully');
    } else {
      Fluttertoast.showToast(msg: 'Failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Text(
              'User Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Email: $email', style: const TextStyle(fontSize: 18)),
            BlocConsumer<UserBloc, UserState>(
              bloc: userBloc,
              listener: (context, state) {
                if (state is UserError) {
                  Fluttertoast.showToast(msg: state.message);
                }
              },
              builder: (context, state) {
                if (state is UserLoaded) {
                  username = state.username;
                }
                return Text('Username: $username', style: Theme.of(context).textTheme.bodyLarge);
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => editProfileDialog(context),
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signOut,
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  void editProfileDialog(BuildContext context) {
    TextEditingController usernameController = TextEditingController(text: username);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'Enter New Username'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                editProfile(usernameController.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void signOut() {
    _auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");
    Fluttertoast.showToast(msg: "User has been signed out");
  }
}
