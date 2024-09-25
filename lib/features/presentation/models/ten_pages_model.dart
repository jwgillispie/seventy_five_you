class TenPages {
  final String date;
  final String firebaseUid;
  final bool completed;
  final String summary;

  TenPages({
    required this.date,
    required this.firebaseUid,
    required this.completed,
    required this.summary,
  });

  factory TenPages.fromJson(Map<String, dynamic> json) {
    return TenPages(
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      completed: json['completed'],
      summary: json['summary'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'completed': completed,
      'summary': summary,
    };
  }
}
