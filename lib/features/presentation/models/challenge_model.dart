// import 'package:seventy_five_hard/features/presentation/models/day_model.dart';
import 'package:seventy_five_hard/features/presentation/mongoDBHelper/mongo_db_constants.dart';

class Challenge {
  final String? firebaseUid;
  final int? challengeNum;
  final String? challengeType;
  final String? startDate;
  final bool? completed;

  Challenge({
    this.firebaseUid,
    this.challengeNum,
    this.challengeType,
    this.startDate,
    this.completed,
  });


  // Factory constructor for creating a Day object from JSON
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      firebaseUid: json['firebase_uid'],
      challengeNum: json['challenge_num'],
      challengeType: json['challenge_type'],
      startDate: json['start_date'],
      // day: json['day'] != null ? Day.fromJson(json['day']) : null,
      completed: json['completed'],
    );
  }

  // Convert Day object to JSON  
  Map<String, dynamic> toJson() {
    return {
      'firebase_uid': firebaseUid,
      'challenge_num': challengeNum,
      'challenge_type': challengeType,
      'start_date': startDate,
      'completed': completed,
    };
  }
}
