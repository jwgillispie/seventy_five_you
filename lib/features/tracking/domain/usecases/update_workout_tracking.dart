//lib/features/tracking/domain/usecases/update_workout_tracking.dart

import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/workout_tracking.dart';
import '../repositories/tracking_repository.dart';

class UpdateWorkoutTracking {
  final TrackingRepository repository;

  UpdateWorkoutTracking(this.repository);

  Future<Either<Failure, WorkoutTracking>> call({
    required String type,
    required String description,
    required String thoughts,
    required bool isOutdoor,
    required Duration duration,
    required int intensity,
    required bool completed,
  }) async {
    return await repository.updateWorkoutTracking(
      type: type,
      description: description,
      thoughts: thoughts,
      isOutdoor: isOutdoor,
      duration: duration,
      intensity: intensity,
      completed: completed,
    );
  }
}