part of 'outside_workout_bloc.dart';

abstract class OutsideWorkoutEvent {}

// describe the workout
class OutsideWorkoutDescriptionSubmittedEvent extends OutsideWorkoutEvent {
  final String description;
  OutsideWorkoutDescriptionSubmittedEvent({required this.description});
}

// list thoughts and feelings
class OutsideWorkoutThoughtsAndFeelingsSubmittedEvent extends OutsideWorkoutEvent {
  final String thoughtsAndFeelings;
  OutsideWorkoutThoughtsAndFeelingsSubmittedEvent(
      {required this.thoughtsAndFeelings});
}
