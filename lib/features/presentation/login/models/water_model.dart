class Water {
  String date;
  String firebaseUid;
  bool completed;
  int peeCount;

  Water({
    this.date = '',
    this.firebaseUid = '',
    this.completed = false,
    this.peeCount = 0,
  });

  factory Water.fromJson(Map<String, dynamic> json) {
    return Water(
      date: json['date'] ?? '',
      firebaseUid: json['firebase_uid'] ?? '',
      completed: json['completed'] ?? false,
      peeCount: json['pee_count'] ?? 0,
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
