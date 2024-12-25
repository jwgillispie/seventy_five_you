class OutsideWorkout {
  String? date;
  String? firebaseUid;
  String? description;
  String? thoughts;
  bool? completed = false;
  String? workoutType;


  OutsideWorkout({
    this.date,
    this.firebaseUid,
    this.description,
    this.thoughts,
    this.completed,
    this.workoutType,
  });

  // Factory constructor for creating a new OutsideWorkout instance from a map
  factory OutsideWorkout.fromJson(Map<String, dynamic> json) {
    return OutsideWorkout(
      date: json['date'] as String?,
      firebaseUid: json['firebase_uid'] as String?,
      description: json['description'] as String?,
      thoughts: json['thoughts'] as String?,
      completed: json['completed'] as bool?,
      workoutType: json['workoutType'] as String?,
    );
  }

  // Method to convert an OutsideWorkout instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'description': description,
      'thoughts': thoughts,
      'completed': completed,
      'workoutType': workoutType,
    };
  }
}
