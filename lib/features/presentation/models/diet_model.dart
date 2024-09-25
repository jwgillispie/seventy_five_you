class Diet {
  final String date;
  final String firebaseUid;
  final List<String> breakfast;
  final List<String> lunch;
  final List<String> dinner;
  final List<String> snacks;

  Diet({
    required this.date,
    required this.firebaseUid,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
  });

  factory Diet.fromJson(Map<String, dynamic> json) {
    return Diet(
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      breakfast: List<String>.from(json['breakfast']),
      lunch: List<String>.from(json['lunch']),
      dinner: List<String>.from(json['dinner']),
      snacks: List<String>.from(json['snacks']),
    );
  }
  // to json
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
      'snacks': snacks,
    };
  }
}
