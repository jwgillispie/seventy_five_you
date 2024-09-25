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
    print("Creating new day object for $firebaseUid");
    DateTime today = DateTime.now();
    String formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    Uri dayUrl = Uri.parse(
        "http://localhost:8000/day/"); // Replace with your backend API URL for day object
    Map<String, String> dayHeaders = {
      'Content-Type': 'application/json',
    };
    InsideWorkout defaultInsideWorkout = InsideWorkout(
      date: formattedDate,
      firebaseUid: firebaseUid,
      description: 'defaultDescription',
      thoughts: 'defaultThoughts',
    );
    OutsideWorkout defaultOutsideWorkout = OutsideWorkout(
      date: formattedDate,
      firebaseUid: firebaseUid,
      description: 'defaultDescription',
      thoughts: 'defaultThoughts',
    );

    Water defaultWater = Water(
      date: formattedDate,
      firebaseUid: firebaseUid,
      completed: false,
      peeCount: 0,
    );

    Alcohol defaultAlcohol = Alcohol(
      date: formattedDate,
      firebaseUid: firebaseUid,
      completed: false,
      difficulty: 0,
    );

    TenPages defaultPages = TenPages(
      date: formattedDate,
      firebaseUid: firebaseUid,
      completed: false,
      summary: 'defaultSummary',
    );
    Diet defaultDiet = Diet(
        date: formattedDate,
        firebaseUid: firebaseUid,
        breakfast: [],
        lunch: [],
        dinner: [],
        snacks: []);
    Map<String, dynamic> dayBody = {
      'date': formattedDate,
      'firebase_uid': firebaseUid,
      'diet': defaultDiet.toJson(),
      'outside_workout': defaultOutsideWorkout.toJson(),
      'inside_workout': defaultInsideWorkout.toJson(),
      'water': defaultWater.toJson(),
      'alcohol': defaultAlcohol.toJson(),
      'pages': defaultPages.toJson(),
    };

    final dayResponse = await http.post(
      dayUrl,
      headers: dayHeaders,
      body: jsonEncode(dayBody),
    );

    if (dayResponse.statusCode == 200) {
      print("Day object successfully sent to backend");
    } else {
      print("Failed to send day object to backend: ${dayResponse.statusCode}");
    }
  }
}
