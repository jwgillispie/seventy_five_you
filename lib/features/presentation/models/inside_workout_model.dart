class InsideWorkout {
  final String date;
  final String firebaseUid;
  final String description;
  final String thoughts;

  InsideWorkout({
    required this.date,
    required this.firebaseUid,
    required this.description,
    required this.thoughts,
  });

  factory InsideWorkout.fromJson(Map<String, dynamic> json) {
    return InsideWorkout(
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      description: json['description'],
      thoughts: json['thoughts'],
    );
  }
  // to json
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'description': description,
      'thoughts': thoughts,
    };
  }
}
