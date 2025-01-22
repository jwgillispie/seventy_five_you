//lib/features/tracking/data/models/workout_tracking_model.dart

import '../../domain/entities/workout_tracking.dart';

class WorkoutTrackingModel extends WorkoutTracking {
  WorkoutTrackingModel({
    required String id,
    required String date,
    required String firebaseUid,
    required String type,
    required String description,
    required String thoughts,
    required bool isOutdoor,
    required Duration duration,
    required int intensity,
    required bool completed,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          date: date,
          firebaseUid: firebaseUid,
          type: type,
          description: description,
          thoughts: thoughts,
          isOutdoor: isOutdoor,
          duration: duration,
          intensity: intensity,
          completed: completed,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory WorkoutTrackingModel.fromJson(Map<String, dynamic> json) {
    return WorkoutTrackingModel(
      id: json['id'],
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      type: json['type'],
      description: json['description'],
      thoughts: json['thoughts'],
      isOutdoor: json['is_outdoor'],
      duration: Duration(minutes: json['duration_minutes']),
      intensity: json['intensity'],
      completed: json['completed'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'firebase_uid': firebaseUid,
      'type': type,
      'description': description,
      'thoughts': thoughts,
      'is_outdoor': isOutdoor,
      'duration_minutes': duration.inMinutes,
      'intensity': intensity,
      'completed': completed,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}