// lib/features/tracking/domain/entities/water_tracking.dart

import 'tracked_item.dart';

class WaterTracking extends TrackedItem {
  final int peeCount;
  final int ouncesDrunk;
  final bool isCompleted;

  WaterTracking({
    required String id,
    required String date,
    required String firebaseUid,
    required this.peeCount,
    required this.ouncesDrunk,
    required this.isCompleted,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          date: date,
          firebaseUid: firebaseUid,
          completed: isCompleted,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
}