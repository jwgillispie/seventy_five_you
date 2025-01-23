abstract class WorkoutEvent {}

class FetchWorkoutData extends WorkoutEvent {
  final String date;
  FetchWorkoutData(this.date);
}

class UpdateWorkoutData extends WorkoutEvent {
  final String date;
  final String description;
  final String thoughts;
  final bool isOutside;

  UpdateWorkoutData({
    required this.date,
    required this.description,
    required this.thoughts,
    required this.isOutside,
  });
}