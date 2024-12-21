class Water {
  String? dayId;
  int? peeCount;
  int? amountFinished;
  bool? completed;


  Water({
    this.dayId,
    this.peeCount,
    this.amountFinished,
    this.completed,
  });

  // Factory constructor for creating a Water object from JSON
  factory Water.fromJson(Map<String, dynamic> json) {
    return Water(
      dayId: json['day_id'],
      peeCount: json['pee_count'],
      amountFinished: json['amount_finished'],
      completed: json['completed'],
    );
  }

  // Convert Water object to JSON  
  Map<String, dynamic> toJson() {
    return {
      'day_id': dayId,
      'pee_count': peeCount,
      'amount_finished': amountFinished,
      'completed': completed,
    };
  }
}
