import 'dart:convert';
import 'package:http/http.dart' as http;

class UserRepository {
  Future<String> fetchUserName(String? userId) async {
    if (userId == null || userId.isEmpty) {
      return 'User not authenticated';
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/user/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['display_name'] ?? 'No username found';
      } else {
        return 'Error retrieving username (Status code: ${response.statusCode})';
      }
    } catch (e) {
      return 'Error retrieving username: ${e.toString()}';
    }
  }
}
