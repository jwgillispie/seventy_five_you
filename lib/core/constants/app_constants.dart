// lib/core/constants/app_constants.dart

class AppConstants {
  // App-wide constants
  static const String appName = '75 Hard';
  static const int splashDuration = 2000;
  static const int totalDays = 75;
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Validation constants
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}