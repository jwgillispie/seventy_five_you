import 'dart:convert';
import 'package:http/http.dart' as http;

class ReadingService {
  static Future<bool> submitReadingData({
    required String userId,
    required String date,
    required String bookTitle,
    required String summary,
    required int pagesRead,
    required bool completed,
  }) async {
    try {
      final readingData = {
        'pages': {
          'date': date,
          'firebase_uid': userId,
          'bookTitle': bookTitle,
          'summary': summary,
          'pagesRead': pagesRead,
          'completed': completed,
        }
      };

      final response = await http.put(
        Uri.parse('http://localhost:8000/day/$userId/$date'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(readingData),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error submitting reading data: $e');
      return false;
    }
  }
}