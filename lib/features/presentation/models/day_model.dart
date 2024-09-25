import 'package:seventy_five_hard/features/presentation/models/diet_model.dart';
import 'package:seventy_five_hard/features/presentation/models/inside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/outside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/alcohol_model.dart';
import 'package:seventy_five_hard/features/presentation/models/ten_pages_model.dart';
import 'package:seventy_five_hard/features/presentation/models/water_model.dart';

class Day {
  final String date;
  final String firebaseUid;
  final Diet diet;
  final OutsideWorkout outsideWorkout;
  final InsideWorkout insideWorkout;
  final Water water;
  final Alcohol alcohol;
  final TenPages pages;

  Day({
    required this.date,
    required this.firebaseUid,
    required this.diet,
    required this.outsideWorkout,
    required this.insideWorkout,
    required this.water,
    required this.alcohol,
    required this.pages,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      date: json['date'] as String,
      firebaseUid: json['firebase_uid'] as String,
      diet: Diet.fromJson(json['diet'] as Map<String, dynamic>),
      outsideWorkout: OutsideWorkout.fromJson(json['outside_workout'] as Map<String, dynamic>),
      insideWorkout: InsideWorkout.fromJson(json['second_workout'] as Map<String, dynamic>),
      water: Water.fromJson(json['water'] as Map<String, dynamic>),
      alcohol: Alcohol.fromJson(json['alcohol'] as Map<String, dynamic>),
      pages: TenPages.fromJson(json['pages'] as Map<String, dynamic>),
    );
  }
  // createa to json function 
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'firebase_uid': firebaseUid,
      'diet': diet.toJson(),
      'outside_workout': outsideWorkout.toJson(),
      'second_workout': insideWorkout.toJson(),
      'water': water.toJson(),
      'alcohol': alcohol.toJson(),
      'pages': pages.toJson(),
    };
  }
}
