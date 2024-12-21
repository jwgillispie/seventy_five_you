class Diet {
  String? dayId;
  List<String>? breakfast;
  List<String>? lunch;
  List<String>? dinner;
  List<String>? snacks;
  bool? completed = false;


  Diet({
    this.dayId,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snacks,
    this.completed,
    
  });

  // Factory constructor for creating a Diet object from JSON
  factory Diet.fromJson(Map<String, dynamic> json) {
    return Diet(
      dayId: json['day_id'] as String,
      breakfast: json['breakfast'] != null
          ? List<String>.from(json['breakfast'] as List<dynamic>)
          : null,
      lunch: json['lunch'] != null
          ? List<String>.from(json['lunch'] as List<dynamic>)
          : null,
      dinner: json['dinner'] != null
          ? List<String>.from(json['dinner'] as List<dynamic>)
          : null,
      snacks: json['snacks'] != null
          ? List<String>.from(json['snacks'] as List<dynamic>)
          : null,
      completed: json['completed'] as bool,
    );
  }

  // Convert Diet object to Json
  Map<String, dynamic> toJson() {
    return {
      'day_id': dayId,
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
      'snacks': snacks,
      'completed': completed,
    };
  }
}
