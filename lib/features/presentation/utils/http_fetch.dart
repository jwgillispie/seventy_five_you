import 'package:http/http.dart' as http;

void fetchData(String endpoint) async {
  final url = Uri.parse('http://10.0.2.2:8000/$endpoint');
  final response = await http.get(url);

  if (endpoint == 'user/') {
    // Successful GET request
    print('Response body: ${response.body}');
  } else {
    // Error handling
    print('Failed to fetch data: ${response.statusCode}');
  }

  if (response.statusCode == 200) {
    // Successful GET request
    print('Response body: ${response.body}');
  } else {
    // Error handling
    print('Failed to fetch data: ${response.statusCode}');
  }
}