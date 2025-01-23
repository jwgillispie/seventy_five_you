class ReadingTrackingModel {
  String? date;
  String? firebaseUid;
  bool? completed;
  String? summary;
  String? bookTitle;
  // pages read 
  int? pagesRead;

  ReadingTrackingModel({
    required this.date,
    required this.firebaseUid,
    required this.completed,
    required this.summary,
    required this.bookTitle,
    required this.pagesRead,
  });

  factory ReadingTrackingModel.fromJson(Map<String, dynamic> json) {
    return ReadingTrackingModel(
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      completed: json['completed'],
      summary: json['summary'],
      bookTitle: json['bookTitle'],
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
      'pagesRead': pagesRead,
      'bookTitle': bookTitle,

    };
  }
}
