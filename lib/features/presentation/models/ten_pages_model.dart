class TenPages {
  String? date;
  String? firebaseUid;
  bool? completed;
  String? summary;
  String? bookTitle;
  // pages read 
  int? pagesRead;

  TenPages({
    required this.date,
    required this.firebaseUid,
    required this.completed,
    required this.summary,
    required this.bookTitle,
    required this.pagesRead,
  });

  factory TenPages.fromJson(Map<String, dynamic> json) {
    return TenPages(
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      completed: json['completed'],
      summary: json['summary'],
      bookTitle: json['book_title'],
      pagesRead: json['pagesRead'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'completed': completed,
      'summary': summary,
      // page read 
      'pagesRead': pagesRead

    };
  }
}
