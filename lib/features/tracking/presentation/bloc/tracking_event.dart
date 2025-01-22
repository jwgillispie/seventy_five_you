//lib/features/tracking/presentation/bloc/tracking_state.dart

part of 'tracking_bloc.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingLoading extends TrackingState {}

class WaterTrackingUpdateSuccess extends TrackingState {
  final WaterTracking tracking;

  const WaterTrackingUpdateSuccess(this.tracking);

  @override
  List<Object> get props => [tracking];
}

class WorkoutTrackingUpdateSuccess extends TrackingState {
  final WorkoutTracking tracking;

  const WorkoutTrackingUpdateSuccess(this.tracking);

  @override
  List<Object> get props => [tracking];
}

class TrackingError extends TrackingState {
  final String message;

  const TrackingError({required this.message});

  @override
  List<Object> get props => [message];
}