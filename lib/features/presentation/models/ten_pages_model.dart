class TenPages {
  String? dayId;
  String? bookTitle;
  int? pagesRead;
  String? summary; 
  bool? completed;


  TenPages({
    this.dayId,
    required this.bookTitle,
    required this.pagesRead,
    required this.summary,
    required this.completed,
  });

  // Factory constructor for creating a TenPages object from JSON
  factory TenPages.fromJson(Map<String, dynamic> json) {
    return TenPages(
      dayId: json['day_id'],
      bookTitle: json['book_title'],
      pagesRead: json['pages_read'],
      summary: json['summary'],
      completed: json['completed'],
    );
  }

  // Convert TenPages object to JSON  
  Map<String, dynamic> toJson() {
    return {
      'day_id': dayId,
      'pages_read': pagesRead,
      'book_title': bookTitle,
      'summary': summary,
      'completed': completed,
    };
  }
}
