// lib/features/home/controllers/home_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'package:seventy_five_hard/features/tracking/data/services/day_service.dart';

class HomeController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DayService _dayService = DayService();
  
  // User data
  String _username = 'Warrior';
  int _streakCount = 0;
  int _completedTasks = 0;
  double _dayProgress = 0.0;
  bool _isLoading = true;
  Day? _todayData;
  int _completedDays = 0;
  
  // Getters
  String get username => _username;
  int get streakCount => _streakCount;
  int get completedTasks => _completedTasks;
  double get dayProgress => _dayProgress;
  bool get isLoading => _isLoading;
  Day? get todayData => _todayData;
  int get completedDays => _completedDays;
  
  // Initialize the controller
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _fetchUserData();
      await _fetchTodayData();
      await _calculateStreak();
      await _countCompletedDays();
    } catch (e) {
      debugPrint('Error initializing home controller: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fetch basic user info
  Future<void> _fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _username = user.displayName ?? 'Warrior';
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }
  
  // Fetch today's challenge data
  Future<void> _fetchTodayData() async {
    try {
      final today = DateTime.now().toString().substring(0, 10);
      _todayData = await _dayService.getOrCreateDay(today);
      
      // Calculate completed tasks
      _completedTasks = 0;
      
      if (_todayData?.water?.completed == true) _completedTasks++;
      if (_todayData?.outsideWorkout?.completed == true) _completedTasks++;
      if (_todayData?.insideWorkout?.completed == true) _completedTasks++;
      if (_todayData?.diet?.completed == true) _completedTasks++;
      if (_todayData?.alcohol?.completed == true) _completedTasks++;
      if (_todayData?.pages?.completed == true) _completedTasks++;
      
      // Calculate day progress
      _dayProgress = _completedTasks / 6;
    } catch (e) {
      debugPrint('Error fetching today data: $e');
    }
  }
  
  // Calculate streak (consecutive days with all tasks completed)
  Future<void> _calculateStreak() async {
    try {
      _streakCount = 0;
      final today = DateTime.now();
      
      // Check the past 75 days for consecutive completed days
      for (int i = 0; i < 75; i++) {
        final checkDate = today.subtract(Duration(days: i));
        final dateString = checkDate.toString().substring(0, 10);
        final dayData = await _dayService.getDayByDate(dateString);
        
        // A day is considered complete when all 6 tasks are done
        final isComplete = dayData != null &&
            dayData.water?.completed == true &&
            dayData.outsideWorkout?.completed == true &&
            dayData.insideWorkout?.completed == true &&
            dayData.diet?.completed == true &&
            dayData.alcohol?.completed == true &&
            dayData.pages?.completed == true;
        
        if (isComplete) {
          _streakCount++;
        } else {
          // Break streak if a day is not complete
          break;
        }
      }
    } catch (e) {
      debugPrint('Error calculating streak: $e');
    }
  }
  
  // Count how many days are fully completed
  Future<void> _countCompletedDays() async {
    try {
      _completedDays = 0;
      final today = DateTime.now();
      
      // Check all days from the start of the challenge
      for (int i = 0; i < 75; i++) {
        final checkDate = today.subtract(Duration(days: i));
        final dateString = checkDate.toString().substring(0, 10);
        final dayData = await _dayService.getDayByDate(dateString);
        
        // A day is considered complete when all 6 tasks are done
        final isComplete = dayData != null &&
            dayData.water?.completed == true &&
            dayData.outsideWorkout?.completed == true &&
            dayData.insideWorkout?.completed == true &&
            dayData.diet?.completed == true &&
            dayData.alcohol?.completed == true &&
            dayData.pages?.completed == true;
        
        if (isComplete) {
          _completedDays++;
        }
      }
    } catch (e) {
      debugPrint('Error counting completed days: $e');
    }
  }
  
  // Refresh data
  Future<void> refresh() async {
    await initialize();
  }
}