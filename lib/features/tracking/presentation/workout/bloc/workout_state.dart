// lib/features/tracking/presentation/workout/bloc/workout_state.dart

import 'package:seventy_five_hard/features/tracking/data/models/inside_workout_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/outside_workout_model.dart';

abstract class WorkoutState {}

class WorkoutInitial extends WorkoutState {}
class WorkoutLoading extends WorkoutState {}
class WorkoutSuccess extends WorkoutState {}
class WorkoutLoaded extends WorkoutState {
  final OutsideWorkout outsideWorkout;
  final InsideWorkout insideWorkout;
  
  WorkoutLoaded({
    required this.outsideWorkout,
    required this.insideWorkout,
  });
}
class WorkoutError extends WorkoutState {
  final String message;
  WorkoutError(this.message);
}