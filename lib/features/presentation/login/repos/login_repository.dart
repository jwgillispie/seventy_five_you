import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import "dart:async";
import 'package:seventy_five_hard/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/presentation/models/alcohol_model.dart';
import 'package:seventy_five_hard/features/presentation/models/ten_pages_model.dart';
import 'package:seventy_five_hard/features/presentation/models/water_model.dart';
import 'package:seventy_five_hard/features/presentation/models/inside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/outside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/diet_model.dart';

class LoginRepository {
  final FirebaseAuthService _auth = FirebaseAuthService();

  Future<User?> signIn(String email, String password) async {
    late User? user;
    try {
      user = await _auth.signInWithEmailAndPassword(email, password);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkIfDayExists(String firebaseUid) async {
    DateTime today = DateTime.now();
    String formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final response = await http.get(
        Uri.parse('http://localhost:8000/day/$firebaseUid/$formattedDate'));

    if (response.statusCode == 200) {
      // If the response status code is 200, check if the response body contains day data
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData.isNotEmpty;
    } else if (response.statusCode == 404) {
      // If the response status code is 404, the day doesn't exist
      print("${formattedDate} not found");
      return false;
    } else {
      // If the request fails for some other reason, return false
      print("${formattedDate} not found for unknown reason");
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
        'pee_count': 0
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
}
