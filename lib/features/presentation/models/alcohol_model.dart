class Alcohol {
  final String date;
  final String firebaseUid;
  final bool completed;
  final int difficulty;

  Alcohol({
    required this.date,
    required this.firebaseUid,
    required this.completed,
    required this.difficulty,
  });

  factory Alcohol.fromJson(Map<String, dynamic> json) {
    return Alcohol(
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      completed: json['completed'],
      difficulty: json['difficulty'],
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
