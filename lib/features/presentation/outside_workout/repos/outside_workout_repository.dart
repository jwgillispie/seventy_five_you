import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/presentation/models/day_model.dart';

class OutsideWorkoutRepository {
  final String baseUrl = 'http://localhost:8000/day'; // Adjust with your actual API URL

  Future<bool> postWorkoutDescription(String description, String firebaseUid) async {
    DateTime today = DateTime.now();
    String formattedDate = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    String url = '$baseUrl/$firebaseUid/$formattedDate';

    // Assuming the API accepts a nested structure for partial updates
    Map<String, dynamic> workoutData = {
      'outside_workout': {  // Make sure this matches the field name in your Day model
        'description': description,
        
        
        // include other fields of outside_workout that need to be updated
      }
    };

    http.Response response = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(workoutData),
    );

    return response.statusCode == 200;
  }

  Future<Day?> getDay(String firebaseUid) async {
    DateTime today = DateTime.now();
    String formattedDate = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final response = await http.get(Uri.parse('$baseUrl/$firebaseUid/$formattedDate'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      Day day = Day.fromJson(responseData);
      return day;
    } else {
      print("Error fetching day: ${response.statusCode}");
      return null;
    }
  }
}
