class Workout {
  String date;
  String type;

  String firebaseUid;
  String workoutType;
  String description;
  String thoughts;
  bool completed = false;


  Workout({
    this.date = '',
    this.type = '',
    this.firebaseUid = '',
    this.workoutType = '',
    this.description = '',
    this.thoughts = '',
    this.completed = false,

  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      date: json['date'] ?? '',
      type: json['type'] ?? '',
      firebaseUid: json['firebase_uid'] ?? '',
      workoutType: json['workout_type'] ?? '',
      description: json['description'] ?? '',
      thoughts: json['thoughts'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'workout_type': workoutType,
      'description': description,
      'thoughts': thoughts,
      'completed': completed,
    };
  }
}
