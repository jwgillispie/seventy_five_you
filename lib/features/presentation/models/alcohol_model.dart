class Alcohol {
      String? dayId;
      int? difficulty;
      bool? completed;
      

  Alcohol({
        this.dayId,
        this.difficulty,
        this.completed,
  });

  // Factory constructor for creating an Alcohol object from JSON
  factory Alcohol.fromJson(Map<String, dynamic> json) {
    return Alcohol(
      dayId: json['day_id'], // Matches Python field name
      difficulty: json['difficulty'],
      completed: json['completed'],
    );
  }
  
  // Convert Alcohol object to JSON  
  Map<String, dynamic> toJson() {
    return {
      'day_id': dayId,
      'difficulty': difficulty,
      'completed': completed,
    };
  }
}
