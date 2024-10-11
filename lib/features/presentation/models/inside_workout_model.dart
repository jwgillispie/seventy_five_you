class InsideWorkout {
    String? date;
    String? firebaseUid;
    String? description;
    String? thoughts;

  InsideWorkout({
      this.date,
      this.firebaseUid,
      this.description,
      this.thoughts,
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
