//lib/features/tracking/domain/usecases/update_water_tracking.dart

import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/water_tracking.dart';
import '../repositories/tracking_repository.dart';

class UpdateWaterTracking {
  final TrackingRepository repository;

  UpdateWaterTracking(this.repository);

  Future<Either<Failure, WaterTracking>> call({
    required int peeCount,
    required int ouncesDrunk,
    required bool completed,
  }) async {
    return await repository.updateWaterTracking(
      peeCount: peeCount,
      ouncesDrunk: ouncesDrunk,
      completed: completed,
    );
  }
}