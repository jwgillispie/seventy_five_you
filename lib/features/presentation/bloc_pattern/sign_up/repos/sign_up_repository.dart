import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class SignUpRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      // Handle exceptions or log errors
      return null;
    }
  }

  Future<bool> sendUserDataToBackend(String firebaseUid, String username, String email, String firstName, String lastName) async {
    Uri userUrl = Uri.parse("http://10.0.2.2:8000/user/");
    Map<String, String> userHeaders = {'Content-Type': 'application/json'};
    Map<String, dynamic> userBody = {
      'firebase_uid': firebaseUid,
      'display_name': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };

    try {
      final userResponse = await http.post(userUrl, headers: userHeaders, body: jsonEncode(userBody));
      return userResponse.statusCode == 200;
    } catch (e) {
      // Handle exceptions or log errors
      return false;
    }
  }

  Future<bool> createNewDay(String firebaseUid) async {
    DateTime today = DateTime.now();
    String formattedDate = "${today.year}-${today.month}-${today.day}";
    Uri dayUrl = Uri.parse("http://10.0.2.2:8000/day/");
    Map<String, String> dayHeaders = {'Content-Type': 'application/json'};
    Map<String, dynamic> dayBody = {
      'date': formattedDate,
      'firebase_uid': firebaseUid,
      // Other fields as needed
    };

    try {
      final dayResponse = await http.post(dayUrl, headers: dayHeaders, body: jsonEncode(dayBody));
      return dayResponse.statusCode == 200;
    } catch (e) {
      // Handle exceptions or log errors
      return false;
    }
  }
}
