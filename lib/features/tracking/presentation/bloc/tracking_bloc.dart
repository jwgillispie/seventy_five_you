//lib/features/tracking/presentation/bloc/tracking_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/water_tracking.dart';
import '../../domain/entities/workout_tracking.dart';
import '../../domain/usecases/update_water_tracking.dart';
import '../../domain/usecases/update_workout_tracking.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final UpdateWaterTracking updateWaterTracking;
  final UpdateWorkoutTracking updateWorkoutTracking;

  TrackingBloc({
    required this.updateWaterTracking,
    required this.updateWorkoutTracking,
  }) : super(TrackingInitial()) {
    on<WaterTrackingUpdated>(_onWaterTrackingUpdated);
    on<WorkoutTrackingUpdated>(_onWorkoutTrackingUpdated);
  }

  Future<void> _onWaterTrackingUpdated(
    WaterTrackingUpdated event,
    Emitter<TrackingState> emit,
  ) async {
    emit(TrackingLoading());

    final result = await updateWaterTracking(
      peeCount: event.peeCount,
      ouncesDrunk: event.ouncesDrunk,
      completed: event.completed,
    );

    result.fold(
      (failure) => emit(TrackingError(message: failure.message)),
      (tracking) => emit(WaterTrackingUpdateSuccess(tracking)),
    );
  }

  Future<void> _onWorkoutTrackingUpdated(
    WorkoutTrackingUpdated event,
    Emitter<TrackingState> emit,
  ) async {
    emit(TrackingLoading());

    final result = await updateWorkoutTracking(
      type: event.type,
      description: event.description,
      thoughts: event.thoughts,
      isOutdoor: event.isOutdoor,
      duration: event.duration,
      intensity: event.intensity,
      completed: event.completed,
    );

    result.fold(
      (failure) => emit(TrackingError(message: failure.message)),
      (tracking) => emit(WorkoutTrackingUpdateSuccess(tracking)),
    );
  }
}