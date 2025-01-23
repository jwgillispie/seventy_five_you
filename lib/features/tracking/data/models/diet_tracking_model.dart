class DietTrackingModel {
  String? date;
  String? firebaseUid;
  List<String>? breakfast;
  List<String>? lunch;
  List<String>? dinner;
  List<String>? snacks;
        bool? completed = false;


  DietTrackingModel({
    this.date,
    this.firebaseUid,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snacks,
    this.completed,
    
  });

  factory DietTrackingModel.fromJson(Map<String, dynamic> json) {
    return DietTrackingModel(
      date: json['date'] as String,
      firebaseUid: json['firebase_uid'] as String,
      breakfast: json['breakfast'] != null
          ? List<String>.from(json['breakfast'] as List<dynamic>)
          : null,
      lunch: json['lunch'] != null
          ? List<String>.from(json['lunch'] as List<dynamic>)
          : null,
      dinner: json['dinner'] != null
          ? List<String>.from(json['dinner'] as List<dynamic>)
          : null,
      snacks: json['snacks'] != null
          ? List<String>.from(json['snacks'] as List<dynamic>)
          : null,
      completed: json['completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
      'snacks': snacks,
      'completed': completed,
    };
  }
}
