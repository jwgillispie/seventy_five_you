class Water {
  final String date;
  final String firebaseUid;
  final bool completed;
  final int peeCount;

  Water({
    required this.date,
    required this.firebaseUid,
    required this.completed,
    required this.peeCount,
  });

  factory Water.fromJson(Map<String, dynamic> json) {
    return Water(
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      completed: json['completed'],
      peeCount: json['pee_count'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'completed': completed,
      'pee_count': peeCount,
    };
  }
}
