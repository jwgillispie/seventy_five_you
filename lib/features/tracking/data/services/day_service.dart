// lib/features/tracking/data/services/day_service.dart

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/core/constants/api_constants.dart';
import 'package:seventy_five_hard/core/errors/exceptions.dart';
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';

class DayService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _baseUrl = ApiConstants.baseUrl;
  
  // Get current user's day data for a specific date
  Future<Day?> getDayByDate(String date) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AuthException(message: 'Not authenticated');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/day/${user.uid}/$date'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return Day.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        // Day not found, return null
        return null;
      } else {
        throw ServerException(message: 'Failed to get day data: ${response.body}');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  // Create or update a day with tracking data
  Future<Day> updateDay(String date, Map<String, dynamic> data) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AuthException(message: 'Not authenticated');
      
      final response = await http.put(
        Uri.parse('$_baseUrl/day/${user.uid}/$date'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      
      if (response.statusCode == 200) {
        return Day.fromJson(json.decode(response.body));
      } else {
        throw ServerException(message: 'Failed to update day: ${response.body}');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  // Initialize a new empty day
  Future<Day> initializeDay(String date) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AuthException(message: 'Not authenticated');
      
      final emptyDay = {
        'date': date,
        'firebase_uid': user.uid,
        'completed': false,
      };
      
      final response = await http.put(
        Uri.parse('$_baseUrl/day/${user.uid}/$date'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(emptyDay),
      );
      
      if (response.statusCode == 200) {
        return Day.fromJson(json.decode(response.body));
      } else {
        throw ServerException(message: 'Failed to initialize day: ${response.body}');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  // Get current user's days between date range
  Future<List<Day>> getDaysInRange(String startDate, String endDate) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AuthException(message: 'Not authenticated');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/days/${user.uid}?start_date=$startDate&end_date=$endDate'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> daysJson = json.decode(response.body);
        return daysJson.map((day) => Day.fromJson(day)).toList();
      } else {
        throw ServerException(message: 'Failed to get days: ${response.body}');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  // Get or initialize a day
  Future<Day> getOrCreateDay(String date) async {
    try {
      final day = await getDayByDate(date);
      if (day != null) {
        return day;
      } else {
        return await initializeDay(date);
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}