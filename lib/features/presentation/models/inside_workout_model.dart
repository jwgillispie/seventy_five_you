class InsideWorkout {
    String? date;
    String? firebaseUid;
    String? description;
    String? thoughts;
          bool? completed = false;


  InsideWorkout({
      this.date,
      this.firebaseUid,
      this.description,
      this.thoughts,
      this.completed,
  });

  factory InsideWorkout.fromJson(Map<String, dynamic> json) {
    return InsideWorkout(
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      description: json['description'],
      thoughts: json['thoughts'],
      completed: json['completed'],
    );
  }
  // to json
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'description': description,
      'thoughts': thoughts,
      'completed': completed,
    };
  }
}
