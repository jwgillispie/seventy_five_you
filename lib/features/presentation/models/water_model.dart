class Water {
  String? date;
  String? firebaseUid;
  bool? completed;
  int? peeCount;

  Water({
    this.date,
    this.firebaseUid,
    this.completed,
    this.peeCount,
  });

  factory Water.fromJson(Map<String, dynamic> json) {
    return Water(
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      completed: json['water'],
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
