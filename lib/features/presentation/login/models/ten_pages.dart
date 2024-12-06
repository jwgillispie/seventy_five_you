class TenPages {
  String date;
  String firebaseUid;
  bool completed;
  String summary;
  String bookTitle;

  TenPages({
    this.date = '',
    this.firebaseUid = '',
    this.completed = false,
    this.summary = '',
    this.bookTitle = '',
  });

  factory TenPages.fromJson(Map<String, dynamic> json) {
    return TenPages(
      date: json['date'] ?? '',
      firebaseUid: json['firebase_uid'] ?? '',
      completed: json['completed'] ?? false,
      summary: json['summary'] ?? '',
      bookTitle: json['book_title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'completed': completed,
      'summary': summary,
      'book_title': bookTitle,
    };
  }
}
