class Reminder {
  String? date;
  String? firebaseUid;
  List<String>? userReminder;

  Reminder({
    this.date,
    this.firebaseUid,
    this.userReminder,
  });
  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      date: json['date'] as String,
      firebaseUid: json['firebase_uid'] as String,
      userReminder: json['user_reminder'] != null
        ? List<String>.from(json['user_reminder'] as List<dynamic>) 
        : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'user_reminder': userReminder,
    };
  }
}
