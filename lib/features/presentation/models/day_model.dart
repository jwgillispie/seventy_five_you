import 'package:seventy_five_hard/features/presentation/models/alcohol_model.dart';
import 'package:seventy_five_hard/features/presentation/models/diet_model.dart';
import 'package:seventy_five_hard/features/presentation/models/inside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/outside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/ten_pages_model.dart';
import 'package:seventy_five_hard/features/presentation/models/water_model.dart';

class Day {
  final String date;
  final String firebaseUid;
  final Diet? diet;
   OutsideWorkout? outsideWorkout;
  final InsideWorkout? insideWorkout;
  final Water? water;
  final Alcohol? alcohol;
  final TenPages? pages;
        bool? completed = false;


  Day({
    required this.date,
    required this.firebaseUid,
    this.diet,
    this.outsideWorkout,
    this.insideWorkout,
    this.water,
    this.alcohol,
    this.pages,
    this.completed,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      date: json['date'] as String,
      firebaseUid: json['firebase_uid'] as String,
      diet: json['diet'] != null
          ? Diet.fromJson(json['diet'] as Map<String, dynamic>)
          : null,
      outsideWorkout: json['outside_workout'] != null
          ? OutsideWorkout.fromJson(json['outside_workout'] as Map<String, dynamic>)
          : null,
      insideWorkout: json['inside_workout'] != null
          ? InsideWorkout.fromJson(json['inside_workout'] as Map<String, dynamic>)
          : null,
      water: json['water'] != null
          ? Water.fromJson(json['water'] as Map<String, dynamic>)
          : null,
      alcohol: json['alcohol'] != null
          ? Alcohol.fromJson(json['alcohol'] as Map<String, dynamic>)
          : null,
      pages: json['pages'] != null
          ? TenPages.fromJson(json['pages'] as Map<String, dynamic>)
          : null,
      completed: json['completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'diet': diet?.toJson(),
      'outside_workout': outsideWorkout?.toJson(),
      'second_workout': insideWorkout?.toJson(),
      'water': water?.toJson(),
      'alcohol': alcohol?.toJson(),
      'pages': pages?.toJson(),
      'completed': completed,
    };
  }
}
