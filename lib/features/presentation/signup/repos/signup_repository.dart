import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:seventy_five_hard/features/presentation/models/alcohol_model.dart';
import 'package:seventy_five_hard/features/presentation/models/ten_pages_model.dart';
import 'package:seventy_five_hard/features/presentation/models/water_model.dart';
import 'package:seventy_five_hard/features/presentation/models/outside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/inside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/diet_model.dart';import "dart:async";
import 'package:seventy_five_hard/features/presentation/models/reminder_model.dart';
import 'package:seventy_five_hard/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupRepository {
  // sign up funciton.. sign up in firebase, send user to mongodb
  FutureOr<User?> signUp(String email, String password) async {
    final FirebaseAuthService _auth = FirebaseAuthService();
    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      return user;
    } catch (e) {
      return null;
    }
  }

  FutureOr<bool> createNewUser(String firebaseUid, String username,
      String email, String firstName, String lastName, List days, List reminder) async {
    print("Creating new user object for $firebaseUid");
    Uri userUrl = Uri.parse("http://localhost:8000/user/");
    Map<String, String> userHeaders = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> userBody = {
      'firebase_uid': firebaseUid,
      'display_name': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'days': days,
      'reminder': reminder
    };

    try {
      final userResponse = await http.post(
        userUrl,
        headers: userHeaders,
        body: jsonEncode(userBody),
      );
      print('user sent to backend');
      return userResponse.statusCode == 200;
    } catch (e) {
      print("Error sending user data to backend: $e");
      return false;
    }
  }

  Future<void> createNewDay(String firebaseUid) async {
    DateTime today = DateTime.now();
    String formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    Map<String, dynamic> dayBody = {
      'date': formattedDate,
      'firebase_uid': firebaseUid,
      'diet': {
        'date': formattedDate,
        'firebase_uid': firebaseUid,
        'breakfast': [],
        'lunch': [],
        'dinner': [],
        'snacks': [],
        'completed': false
      },
      'outside_workout': {
        'date': formattedDate,
        'firebase_uid': firebaseUid,
        'description': 'defaultDescription',
        'thoughts': 'defaultThoughts',
        'completed': false
      },
      'inside_workout': {
        'date': formattedDate,
        'firebase_uid': firebaseUid,
        'description': 'defaultDescription',
        'thoughts': 'defaultThoughts',
        'completed': false
      },
      'water': {
        'date': formattedDate,
        'firebase_uid': firebaseUid,
        'completed': false,
        'peeCount': 0,
        'ouncesDrunk': 0
      },
      'alcohol': {
        'date': formattedDate,
        'firebase_uid': firebaseUid,
        'completed': false,
        'difficulty': 0
      },
      'pages': {
        'date': formattedDate,
        'firebase_uid': firebaseUid,
        'completed': false,
        'summary': 'defaultSummary',
        'bookTitle': 'defaultBookTitle',
        'pagesRead': 0
      }
    };

    final response = await http.post(
      Uri.parse('http://localhost:8000/day/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dayBody),
    );

    if (response.statusCode != 200) {
      print("Failed to create day: ${response.statusCode} - ${response.body}");
      throw Exception("Failed to create day");
    }
  }
  // function to get current user and add day object to user object's days array
  FutureOr<bool> addDayToUser(String firebaseUid) async {
    print("Adding day object to user object for $firebaseUid");
    DateTime today = DateTime.now();
    String formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    Uri userUrl = Uri.parse("http://localhost:8000/user/$firebaseUid");
    Map<String, String> userHeaders = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> userBody = {
      'days': {
        'date': formattedDate,
        'diet': {
          'breakfast': [],
          'lunch': [],
          'dinner': [],
          'snacks': [],
        },
        'outside_workout': {
          'date': formattedDate,
          'firebase_uid': firebaseUid,
          'description': 'defaultDescription',
          'thoughts': 'defaultThoughts',
        },
        'inside_workout': {
          'date': formattedDate,
          'firebase_uid': firebaseUid,
          'description': 'defaultDescription',
          'thoughts': 'defaultThoughts',
        },
        'water': {
          'date': formattedDate,
          'firebase_uid': firebaseUid,
          'completed': false,
          'peeCount': 0,
          'ouncesDrunk': 0,

        },
        'alcohol': {
          'date': formattedDate,
          'firebase_uid': firebaseUid,
          'completed': false,
          'difficulty': 0,
        },
        'pages': {
          'date': formattedDate,
          'firebase_uid': firebaseUid,
          'completed': false,
          'summary': 'defaultSummary',
        },
      }
    };

    try {
      final userResponse = await http.put(
        userUrl,
        headers: userHeaders,
        body: jsonEncode(userBody),
      );
      print('day added to user');
      return userResponse.statusCode == 200;
    } catch (e) {
      print("Error adding day to user: $e");
      return false;
    }

  }
  /// function to get user object from mongodb
  FutureOr<Map<String, dynamic>> getUser(String firebaseUid) async {
    print("Getting user object for $firebaseUid");
    Uri userUrl = Uri.parse("http://localhost:8000/user/$firebaseUid");
    Map<String, String> userHeaders = {
      'Content-Type': 'application/json',
    };

    try {
      final userResponse = await http.get(
        userUrl,
        headers: userHeaders,
      );
      print('user fetched from backend');
      return jsonDecode(userResponse.body);
    } catch (e) {
      print("Error fetching user data from backend: $e");
      return {};
    }
  }
}
