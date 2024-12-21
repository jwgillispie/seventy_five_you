class OutsideWorkout {
  String? dayId;
  String? description;
  String? thoughts;
  bool? completed = false;


  OutsideWorkout({
    this.dayId,
    this.description,
    this.thoughts,
    this.completed,
  });

  // Factory constructor for creating a new OutsideWorkout instance from a map
  factory OutsideWorkout.fromJson(Map<String, dynamic> json) {
    return OutsideWorkout(
      dayId: json['day_id'],
      description: json['description'] as String?,
      thoughts: json['thoughts'] as String?,
      completed: json['completed'] as bool?,
    );
  }

  // Method to convert an OutsideWorkout instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'day_id': dayId,
      'description': description,
      'thoughts': thoughts,
      'completed': completed,
    };
  }
}
