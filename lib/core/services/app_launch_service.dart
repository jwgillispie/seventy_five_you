// lib/core/services/app_launch_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'package:seventy_five_hard/features/tracking/data/services/day_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seventy_five_hard/features/tracking/data/models/water_tracking_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/inside_workout_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/outside_workout_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/reading_tracking_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/diet_tracking_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/alcohol_tracking_model.dart';

class AppLaunchService {
  static final AppLaunchService _instance = AppLaunchService._internal();
  factory AppLaunchService() => _instance;
  AppLaunchService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DayService _dayService = DayService();
  
  // Keys for SharedPreferences
  static const String _lastActiveDay = 'last_active_day';
  static const String _currentStreakKey = 'current_streak';
  static const String _totalCompletedDaysKey = 'total_completed_days';
  static const String _challengeStartDateKey = 'challenge_start_date';
  
  // Initialize app data
  Future<void> initialize() async {
    try {
      // Check if there's a logged-in user
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('AppLaunchService: No logged-in user found');
        return;
      }
      
      // Check if this is a new day
      final isNew = await isNewDay();
      if (isNew) {
        debugPrint('AppLaunchService: This is a new day');
      }
      
      // Initialize today's data if it doesn't exist
      await _initializeTodayData();
      
      // Update streak count
      await updateUserStreak();
      
      // Set last active day to today
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_lastActiveDay, getTodayDateString());
      
      debugPrint('AppLaunchService: App data initialized successfully');
    } catch (e) {
      debugPrint('AppLaunchService: Error initializing app data: $e');
    }
  }
  
  // Ensure today's data exists
  Future<void> _initializeTodayData() async {
    final today = getTodayDateString();
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      // Check if today's data exists
      final dayData = await _dayService.getDayByDate(today);
      
      // If not, create an empty day
      if (dayData == null) {
        debugPrint('AppLaunchService: Creating data for today: $today');
        
        // Create a simple empty water tracking model
        final waterData = {
          'date': today,
          'firebase_uid': user.uid,
          'completed': false,
          'peeCount': 0,
          'ouncesDrunk': 0
        };
        
        final emptyInsideWorkout = InsideWorkout(
          date: today,
          firebaseUid: user.uid,
          description: '',
          thoughts: '',
          completed: false,
          workoutType: '',
        );
        
        final emptyOutsideWorkout = OutsideWorkout(
          date: today,
          firebaseUid: user.uid,
          description: '',
          thoughts: '',
          completed: false,
          workoutType: '',
        );
        
        final emptyReading = ReadingTrackingModel(
          date: today,
          firebaseUid: user.uid,
          completed: false,
          summary: '',
          bookTitle: '',
          pagesRead: 0,
        );
        
        final emptyDiet = DietTrackingModel(
          date: today,
          firebaseUid: user.uid,
          breakfast: [],
          lunch: [],
          dinner: [],
          snacks: [],
          completed: false,
        );
        
        final emptyAlcohol = AlcoholTrackingModel(
          date: today,
          firebaseUid: user.uid,
          completed: false,
          difficulty: 5,
        );
        
        // Create empty day with all tracking objects
        final emptyDay = {
          'date': today,
          'firebase_uid': user.uid,
          'completed': false,
          'water': waterData,
          'inside_workout': emptyInsideWorkout.toJson(),
          'outside_workout': emptyOutsideWorkout.toJson(),
          'pages': emptyReading.toJson(),
          'diet': emptyDiet.toJson(),
          'alcohol': emptyAlcohol.toJson(),
        };
        
        await _dayService.updateDay(today, emptyDay);
      } else {
        debugPrint('AppLaunchService: Today\'s data already exists');
      }
    } catch (e) {
      debugPrint('AppLaunchService: Error checking today\'s data: $e');
    }
  }
  
  // Check and update user streak
  Future<void> updateUserStreak() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      
      final prefs = await SharedPreferences.getInstance();
      int currentStreak = prefs.getInt(_currentStreakKey) ?? 0;
      
      // Get yesterday's date
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayString = yesterday.toString().substring(0, 10);
      
      // Check if yesterday's tasks were completed
      final yesterdayData = await _dayService.getDayByDate(yesterdayString);
      
      // A day is complete when all 6 tasks are done
      final yesterdayComplete = yesterdayData != null &&
          yesterdayData.water?.completed == true &&
          yesterdayData.outsideWorkout?.completed == true &&
          yesterdayData.insideWorkout?.completed == true &&
          yesterdayData.diet?.completed == true &&
          yesterdayData.alcohol?.completed == true &&
          yesterdayData.pages?.completed == true;
      
      // Get last active day from SharedPreferences
      final lastActive = prefs.getString(_lastActiveDay);
      
      if (lastActive != null && lastActive != yesterdayString && !yesterdayComplete) {
        // If user missed a day, reset streak
        currentStreak = 0;
        debugPrint('AppLaunchService: Streak reset due to missed day');
      } else if (yesterdayComplete) {
        // If yesterday was complete, increase streak
        currentStreak++;
        debugPrint('AppLaunchService: Streak increased to $currentStreak');
      }
      
      // Save updated streak
      prefs.setInt(_currentStreakKey, currentStreak);
      
    } catch (e) {
      debugPrint('AppLaunchService: Error updating user streak: $e');
    }
  }
  
  // Get current streak count
  Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentStreakKey) ?? 0;
  }
  
  // Get total completed days
  Future<int> getTotalCompletedDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalCompletedDaysKey) ?? 0;
  }
  
  // Set challenge start date
  Future<void> setChallengeStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dateString = now.toString().substring(0, 10);
    
    // Only set if not already set
    if (prefs.getString(_challengeStartDateKey) == null) {
      prefs.setString(_challengeStartDateKey, dateString);
      debugPrint('AppLaunchService: Set challenge start date to $dateString');
    }
  }
  
  // Get days elapsed in challenge
  Future<int> getDaysInChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    final startDateStr = prefs.getString(_challengeStartDateKey);
    
    if (startDateStr == null) {
      // If no start date, set it now and return 1
      await setChallengeStartDate();
      return 1;
    }
    
    // Calculate days since start
    final startDate = DateTime.parse(startDateStr);
    final now = DateTime.now();
    return now.difference(startDate).inDays + 1;
  }
  
  // Check if this is a new day compared to last active day
  Future<bool> isNewDay() async {
    final prefs = await SharedPreferences.getInstance();
    final lastActive = prefs.getString(_lastActiveDay);
    final today = getTodayDateString();
    
    if (lastActive == null || lastActive != today) {
      return true;
    }
    return false;
  }
  
  // Get today's date string
  String getTodayDateString() {
    return DateTime.now().toString().substring(0, 10);
  }
  
  // Update completed days count
  Future<void> updateCompletedDaysCount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      
      final prefs = await SharedPreferences.getInstance();
      int completedDays = 0;
      
      // Count completed days in the past
      final startDate = DateTime.now().subtract(const Duration(days: 75)); // Go back 75 days max
      
      for (int i = 0; i < 75; i++) {
        final checkDate = startDate.add(Duration(days: i));
        final checkDateStr = checkDate.toString().substring(0, 10);
        
        // Skip future dates
        if (checkDate.isAfter(DateTime.now())) continue;
        
        final dayData = await _dayService.getDayByDate(checkDateStr);
        
        // A day is complete when all 6 tasks are done
        final isDayComplete = dayData != null &&
            dayData.water?.completed == true &&
            dayData.outsideWorkout?.completed == true &&
            dayData.insideWorkout?.completed == true &&
            dayData.diet?.completed == true &&
            dayData.alcohol?.completed == true &&
            dayData.pages?.completed == true;
        
        if (isDayComplete) {
          completedDays++;
        }
      }
      
      // Save the count
      prefs.setInt(_totalCompletedDaysKey, completedDays);
      debugPrint('AppLaunchService: Updated completed days count to $completedDays');
      
    } catch (e) {
      debugPrint('AppLaunchService: Error updating completed days count: $e');
    }
  }
  
  // Check if day is complete
  Future<bool> isDayComplete(String date) async {
    try {
      final dayData = await _dayService.getDayByDate(date);
      
      return dayData != null &&
          dayData.water?.completed == true &&
          dayData.outsideWorkout?.completed == true &&
          dayData.insideWorkout?.completed == true &&
          dayData.diet?.completed == true &&
          dayData.alcohol?.completed == true &&
          dayData.pages?.completed == true;
    } catch (e) {
      debugPrint('AppLaunchService: Error checking if day is complete: $e');
      return false;
    }
  }
  
  // Check if challenge is complete (75 days)
  Future<bool> isChallengeComplete() async {
    final totalDays = await getTotalCompletedDays();
    return totalDays >= 75;
  }
}