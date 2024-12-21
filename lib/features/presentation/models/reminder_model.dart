class Reminder {
  String? userId;
  List<String>? userReminder;

  Reminder({
    this.userId,
    this.userReminder,
  });

  // Factory constructor for creating a Reminder object from JSON
  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      userId: json['user_id'],
      userReminder: json['user_reminder'] != null
        ? List<String>.from(json['user_reminder'] as List<dynamic>) 
        : null,
    );
  }

  // Convert Reminder object to JSON  
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_reminder': userReminder,
    };
  }
}
