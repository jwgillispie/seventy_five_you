// lib/core/constants/api_constants.dart

class ApiConstants {
  static const String baseUrl = 'http://localhost:8000';
  static const String userEndpoint = '/user';
  static const String dayEndpoint = '/day';
  static const Duration timeoutDuration = Duration(seconds: 30);
  
  // Auth endpoints
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}