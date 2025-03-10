//lib/core/network/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client _client;
  
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    print("ApiClient: GET request to ${ApiConstants.baseUrl + endpoint}");
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.baseUrl + endpoint),
        headers: {...ApiConstants.headers, ...?headers},
      ).timeout(ApiConstants.timeoutDuration);

      print("ApiClient: GET response status code: ${response.statusCode}");
      print("ApiClient: GET response body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...");
      
      return _handleResponse(response);
    } catch (e) {
      print("ApiClient: GET request failed with error: $e");
      throw NetworkException(message: e.toString());
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    print("ApiClient: POST request to ${ApiConstants.baseUrl + endpoint}");
    print("ApiClient: POST request body: $body");
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.baseUrl + endpoint),
        headers: {...ApiConstants.headers, ...?headers},
        body: json.encode(body),
      ).timeout(ApiConstants.timeoutDuration);

      print("ApiClient: POST response status code: ${response.statusCode}");
      print("ApiClient: POST response body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...");
      
      return _handleResponse(response);
    } catch (e) {
      print("ApiClient: POST request failed with error: $e");
      throw NetworkException(message: e.toString());
    }
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    print("ApiClient: PUT request to ${ApiConstants.baseUrl + endpoint}");
    print("ApiClient: PUT request body: $body");
    try {
      final response = await _client.put(
        Uri.parse(ApiConstants.baseUrl + endpoint),
        headers: {...ApiConstants.headers, ...?headers},
        body: json.encode(body),
      ).timeout(ApiConstants.timeoutDuration);

      print("ApiClient: PUT response status code: ${response.statusCode}");
      print("ApiClient: PUT response body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...");
      
      return _handleResponse(response);
    } catch (e) {
      print("ApiClient: PUT request failed with error: $e");
      throw NetworkException(message: e.toString());
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body);
      } catch (e) {
        print("ApiClient: Failed to decode JSON response: $e");
        throw ServerException(
          message: 'Invalid response format',
          statusCode: response.statusCode,
        );
      }
    } else {
      print("ApiClient: Server error with status code: ${response.statusCode}");
      throw ServerException(
        message: response.body,
        statusCode: response.statusCode,
      );
    }
  }
}