class SecondWorkout {
    String? dayId;
    String? description;
    String? thoughts;
    bool? completed = false;


  SecondWorkout({
      this.dayId,
      this.description,
      this.thoughts,
      this.completed,
  });

  // Factory constructor for creating a SecondWorkout object from JSON
  factory SecondWorkout.fromJson(Map<String, dynamic> json) {
    return SecondWorkout(
      dayId: json['day_id'],
      description: json['description'],
      thoughts: json['thoughts'],
      completed: json['completed'],
    );
  }

  // Convert SecondWorkout object to JSON  
  Map<String, dynamic> toJson() {
    return {
      'day_id': dayId,
      'description': description,
      'thoughts': thoughts,
      'completed': completed,
    };
  }
}
