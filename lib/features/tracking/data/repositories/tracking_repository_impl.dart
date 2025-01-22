//lib/features/tracking/data/repositories/tracking_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/water_tracking.dart';
import '../../domain/entities/workout_tracking.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../../../../tracking/data/datasources/tracking_remote_datasource.dart';
import '../models/water_tracking_model.dart';
import '../models/workout_tracking_model.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TrackingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WaterTracking>> getWaterTracking(String date) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getWaterTracking(date);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, WaterTracking>> updateWaterTracking({
    required int peeCount,
    required int ouncesDrunk,
    required bool completed,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final model = WaterTrackingModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: DateTime.now().toIso8601String().split('T')[0],
          firebaseUid: '',  // Will be set by remote data source
          peeCount: peeCount,
          ouncesDrunk: ouncesDrunk,
          isCompleted: completed,
          createdAt: DateTime.now(),
        );
        
        final result = await remoteDataSource.updateWaterTracking(model);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, WorkoutTracking>> getWorkoutTracking(String date) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getWorkoutTracking(date);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, WorkoutTracking>> updateWorkoutTracking({
    required String type,
    required String description,
    required String thoughts,
    required bool isOutdoor,
    required Duration duration,
    required int intensity,
    required bool completed,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final model = WorkoutTrackingModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: DateTime.now().toIso8601String().split('T')[0],
          firebaseUid: '',  // Will be set by remote data source
          type: type,
          description: description,
          thoughts: thoughts,
          isOutdoor: isOutdoor,
          duration: duration,
          intensity: intensity,
          completed: completed,
          createdAt: DateTime.now(),
        );
        
        final result = await remoteDataSource.updateWorkoutTracking(model);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}