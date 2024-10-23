class Reminders {
      String? date;
      String? firebaseUid;
      List<String>? userReminders;

  Reminders({
        this.date,
        this.firebaseUid,
        this.userReminders,
  });

  factory Reminders.fromJson(Map<String, dynamic> json) {
    return Reminders(
      date: json['date'] as String,
      firebaseUid: json['firebase_uid'] as String,
      userReminders: json['user_reminders'] != null
        ? List<String>.from(json['user_reminders'] as List<dynamic>) 
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'user_reminders': userReminders,
    };
  }
}