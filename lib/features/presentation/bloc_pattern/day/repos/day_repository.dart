import 'dart:convert';
import 'package:http/http.dart' as http;

class DayRepository {
  static const String baseUrl = 'http://10.0.2.2:8000';
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
  Future<bool> checkIfDayExists(String firebaseUid, String date) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/day/$firebaseUid/$date'));
      if (response.statusCode == 200) {
        return json.decode(response.body).isNotEmpty;
      } else if (response.statusCode == 404) {
        return false;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error checking if day exists: $e');
      return false;
    }
  }

  Future<bool> createNewDay(String firebaseUid, String date) async {
    try {
      Uri dayUrl = Uri.parse('$baseUrl/day/');
      Map<String, dynamic> dayBody = {
        'date': date,
        'firebase_uid': firebaseUid,
        'diet': [],
        'outside_workout': [],
        'second_workout': [],
        'water': 0,
        'alcohol': 0,
        'pages': 0,
      };

      final dayResponse = await http.post(
        dayUrl,
        headers: defaultHeaders,
        body: jsonEncode(dayBody),
      );

      return dayResponse.statusCode == 200;
    } catch (e) {
      print('Error creating new day: $e');
      return false;
    }
  }

  // Implement create, update, and delete methods
}
