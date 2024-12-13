class Water {
  String? date;
  String? firebaseUid;
  bool? completed;
  int? peeCount;
  int? ouncesDrunk;

  Water({
    this.date,
    this.firebaseUid,
    this.completed,
    this.peeCount,
    this.ouncesDrunk,
  });

  factory Water.fromJson(Map<String, dynamic> json) {
    return Water(
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      completed: json['water'],
      peeCount: json['peeCount'],
      ouncesDrunk: json['ouncesDrunk'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'completed': completed,
      'peeCount': peeCount,
      'ouncesDrunk': ouncesDrunk,
    };
  }
}
