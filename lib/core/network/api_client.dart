//lib/core/network/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client _client;
  
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.baseUrl + endpoint),
        headers: {...ApiConstants.headers, ...?headers},
      ).timeout(ApiConstants.timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.baseUrl + endpoint),
        headers: {...ApiConstants.headers, ...?headers},
        body: json.encode(body),
      ).timeout(ApiConstants.timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse(ApiConstants.baseUrl + endpoint),
        headers: {...ApiConstants.headers, ...?headers},
        body: json.encode(body),
      ).timeout(ApiConstants.timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw ServerException(
        message: response.body,
        statusCode: response.statusCode,
      );
    }
  }
}