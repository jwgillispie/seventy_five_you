class AlcoholTrackingModel {
      String? date;
      String? firebaseUid;
      bool? completed;
      int? difficulty;
      

  AlcoholTrackingModel({
        this.date,
        this.firebaseUid,
        this.completed,
        this.difficulty,
  });

  factory AlcoholTrackingModel.fromJson(Map<String, dynamic> json) {
    return AlcoholTrackingModel(
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
