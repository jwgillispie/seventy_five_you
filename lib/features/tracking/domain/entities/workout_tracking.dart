// lib/features/tracking/domain/entities/workout_tracking.dart

import 'tracked_item.dart';

class WorkoutTracking extends TrackedItem {
  final String type;
  final String description;
  final String thoughts;
  final bool isOutdoor;
  final Duration duration;
  final int intensity;

  WorkoutTracking({
    required String id,
    required String date,
    required String firebaseUid,
    required this.type,
    required this.description,
    required this.thoughts,
    required this.isOutdoor,
    required this.duration,
    required this.intensity,
    required bool completed,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          date: date,
          firebaseUid: firebaseUid,
          completed: completed,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
}