import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:seventy_five_hard/features/presentation/models/challenge_model.dart';
import 'package:seventy_five_hard/features/presentation/models/alcohol_model.dart';
import 'package:seventy_five_hard/features/presentation/models/ten_pages_model.dart';
import 'package:seventy_five_hard/features/presentation/models/water_model.dart';
import 'package:seventy_five_hard/features/presentation/models/outside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/second_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/diet_model.dart';
import "dart:async";
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
      String email, String firstName, String lastName) async {
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
      'last_name': lastName
    };

    try {
      final userResponse = await http.post(
        userUrl,
        headers: userHeaders,
        body: jsonEncode(userBody),
      );
      print(userBody);
      print('user sent to backend');
      return userResponse.statusCode == 200;
    } catch (e) {
      print("Error sending user data to backend: $e");
      return false;
    }
  }

  // createNewChallenge function.. send day object to mongo db for user
  Future<String?> createNewChallenge(String firebaseUid) async {
    print("Creating new challenge object for $firebaseUid");
    DateTime today = DateTime.now();
    String formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    Uri challengeUrl = Uri.parse(
        "http://localhost:8000/challenge/");
    Map<String, String> challengeHeaders = {
      'Content-Type': 'application/json',
    };

    // Construct the challenge object
    Map<String, dynamic> challengeBody = {
      'firebase_uid': firebaseUid,
      'challenge_num': 1, // Example: Challenge #1
      'challenge_type': 'Hard',
      'start_date': formattedDate,
      'completed': false, // Initial status of the challenge
    };

    // Send the challenge object to backend
    try {
      final challengeResponse = await http.post(
        challengeUrl,
        headers: challengeHeaders,
        body: jsonEncode(challengeBody),
      );

      print(challengeBody);

      if (challengeResponse.statusCode == 200 || challengeResponse.statusCode == 201) {
        print("Challenge object successfully sent to backend");
        final responseBody = jsonDecode(challengeResponse.body);
        print('challengeResponse: $challengeResponse');
        print('responseBody: $responseBody');
        return responseBody['_id']; // MongoDB will return the challenge's `_id` in the response
      } else {
        print("Failed to send challenge object to backend: ${challengeResponse.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error sending challenge object: $e");
      return null;
    }
  }

  // createDay function.. send day object to mongo db for user
  Future<void> createNewDay(String challengeId) async {
    print("Creating new day object for $challengeId");
    DateTime today = DateTime.now();
    String formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    Uri dayUrl = Uri.parse(
        "http://localhost:8000/day/"); // Replace with your backend API URL for day object
    Map<String, String> dayHeaders = {
      'Content-Type': 'application/json',
    };
  
    Map<String, dynamic> dayBody = {
      'challenge_id': challengeId,
      'date': formattedDate,
      'completed': false,
    };


    try {
      final dayResponse = await http.post(
        dayUrl,
        headers: dayHeaders,
        body: jsonEncode(dayBody),
      );

      if (dayResponse.statusCode == 200 || dayResponse.statusCode == 201) {
          print("Day object successfully sent to backend");
        } else {
          print("Failed to send day object to backend: ${dayResponse.statusCode}");
        }

    } catch (e) {
      print("Error sending day object: $e");
    }
  }


  // function to get user object from mongodb
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



// function to get current user and add day object to user object's days array
  // FutureOr<bool> addDayToUser(String firebaseUid) async {
  //   print("Adding day object to user object for $firebaseUid");
  //   DateTime today = DateTime.now();
  //   String formattedDate =
  //       "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

  //   Uri userUrl = Uri.parse("http://localhost:8000/user/$firebaseUid");
  //   Map<String, String> userHeaders = {
  //     'Content-Type': 'application/json',
  //   };

  //   Map<String, dynamic> userBody = {
  //     'days': {
  //       'date': formattedDate,
  //       'diet': {
  //         'breakfast': [],
  //         'lunch': [],
  //         'dinner': [],
  //         'snacks': [],
  //       },
  //       'outside_workout': {
  //         'date': formattedDate,
  //         'firebase_uid': firebaseUid,
  //         'description': 'defaultDescription',
  //         'thoughts': 'defaultThoughts',
  //       },
  //       'inside_workout': {
  //         'date': formattedDate,
  //         'firebase_uid': firebaseUid,
  //         'description': 'defaultDescription',
  //         'thoughts': 'defaultThoughts',
  //       },
  //       'water': {
  //         'date': formattedDate,
  //         'firebase_uid': firebaseUid,
  //         'completed': false,
  //         'peeCount': 0,
  //         'ouncesDrunk': 0,

  //       },
  //       'alcohol': {
  //         'date': formattedDate,
  //         'firebase_uid': firebaseUid,
  //         'completed': false,
  //         'difficulty': 0,
  //       },
  //       'pages': {
  //         'date': formattedDate,
  //         'firebase_uid': firebaseUid,
  //         'completed': false,
  //         'summary': 'defaultSummary',
  //       },
  //     }
  //   };

  //   try {
  //     final userResponse = await http.put(
  //       userUrl,
  //       headers: userHeaders,
  //       body: jsonEncode(userBody),
  //     );
  //     print('day added to user');
  //     return userResponse.statusCode == 200;
  //   } catch (e) {
  //     print("Error adding day to user: $e");
  //     return false;
  //   }
  // }