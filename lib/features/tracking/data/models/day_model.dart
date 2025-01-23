// lib/features/tracking/domain/entities/day.dart

import 'package:seventy_five_hard/features/tracking/data/models/water_tracking_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/diet_tracking_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/inside_workout_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/outside_workout_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/reading_tracking_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/alcohol_tracking_model.dart';

class Day {
  final WaterTrackingModel? water;
  final DietTrackingModel? diet;
  final InsideWorkout? insideWorkout;
  final OutsideWorkout? outsideWorkout;
  final ReadingTrackingModel? pages;
  final AlcoholTrackingModel? alcohol;
  final String date;
  final String firebaseUid;
  final bool completed;

  Day({
    this.water,
    this.diet,
    this.insideWorkout,
    this.outsideWorkout,
    this.pages,
    this.alcohol,
    required this.date,
    required this.firebaseUid,
    this.completed = false,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      date: json['date'] ?? '',
      firebaseUid: json['firebase_uid'] ?? '',
      completed: json['completed'] ?? false,
      water: json['water'] != null 
          ? WaterTrackingModel.fromJson(json['water'])
          : null,
      diet: json['diet'] != null 
          ? DietTrackingModel.fromJson(json['diet'])
          : null,
      insideWorkout: json['inside_workout'] != null
          ? InsideWorkout.fromJson(json['inside_workout'])
          : null,
      outsideWorkout: json['outside_workout'] != null
          ? OutsideWorkout.fromJson(json['outside_workout'])
          : null,
      pages: json['pages'] != null
          ? ReadingTrackingModel.fromJson(json['pages'])
          : null,
      alcohol: json['alcohol'] != null
          ? AlcoholTrackingModel.fromJson(json['alcohol'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'completed': completed,
      'water': water?.toJson(),
      'diet': diet?.toJson(),
      'inside_workout': insideWorkout?.toJson(),
      'outside_workout': outsideWorkout?.toJson(),
      'pages': pages?.toJson(),
      'alcohol': alcohol?.toJson(),
    };
  }

  Day copyWith({
    WaterTrackingModel? water,
    DietTrackingModel? diet,
    InsideWorkout? insideWorkout,
    OutsideWorkout? outsideWorkout,
    ReadingTrackingModel? pages,
    AlcoholTrackingModel? alcohol,
    String? date,
    String? firebaseUid,
    bool? completed,
  }) {
    return Day(
      water: water ?? this.water,
      diet: diet ?? this.diet,
      insideWorkout: insideWorkout ?? this.insideWorkout,
      outsideWorkout: outsideWorkout ?? this.outsideWorkout,
      pages: pages ?? this.pages,
      alcohol: alcohol ?? this.alcohol,
      date: date ?? this.date,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      completed: completed ?? this.completed,
    );
  }
}