//lib/features/tracking/domain/repositories/tracking_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/water_tracking.dart';
import '../entities/workout_tracking.dart';

abstract class TrackingRepository {
  Future<Either<Failure, WaterTracking>> getWaterTracking(String date);
  Future<Either<Failure, WaterTracking>> updateWaterTracking({
    required int peeCount,
    required int ouncesDrunk,
    required bool completed,
  });
  
  Future<Either<Failure, WorkoutTracking>> getWorkoutTracking(String date);
  Future<Either<Failure, WorkoutTracking>> updateWorkoutTracking({
    required String type,
    required String description,
    required String thoughts,
    required bool isOutdoor,
    required Duration duration,
    required int intensity,
    required bool completed,
  });
}