class Alcohol {
  String date;
  String firebaseUid;
  bool completed;
  int difficulty;

  Alcohol({
    this.date = '',
    this.firebaseUid = '',
    this.completed = false,
    this.difficulty = 0,
  });

  factory Alcohol.fromJson(Map<String, dynamic> json) {
    return Alcohol(
      date: json['date'] ?? '',
      firebaseUid: json['firebase_uid'] ?? '',
      completed: json['completed'] ?? false,
      difficulty: json['difficulty'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'completed': completed,
      'difficulty': difficulty,
    };
  }
}
