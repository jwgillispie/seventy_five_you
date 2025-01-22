//lib/features/tracking/data/models/water_tracking_model.dart

import '../../domain/entities/water_tracking.dart';

class WaterTrackingModel extends WaterTracking {
  WaterTrackingModel({
    required String id,
    required String date,
    required String firebaseUid,
    required int peeCount,
    required int ouncesDrunk,
    required bool isCompleted,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          date: date,
          firebaseUid: firebaseUid,
          peeCount: peeCount,
          ouncesDrunk: ouncesDrunk,
          isCompleted: isCompleted,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory WaterTrackingModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackingModel(
      id: json['id'],
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      peeCount: json['pee_count'],
      ouncesDrunk: json['ounces_drunk'],
      isCompleted: json['completed'],
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
      'pee_count': peeCount,
      'ounces_drunk': ouncesDrunk,
      'completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}