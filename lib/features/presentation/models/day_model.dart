import 'package:seventy_five_hard/features/presentation/models/alcohol_model.dart';
import 'package:seventy_five_hard/features/presentation/models/diet_model.dart';
import 'package:seventy_five_hard/features/presentation/models/inside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/outside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/ten_pages_model.dart';
import 'package:seventy_five_hard/features/presentation/models/water_model.dart';

class Day {
  final Water? water;
  final Diet? diet;
  final InsideWorkout? insideWorkout;
  final OutsideWorkout? outsideWorkout;
  final TenPages? pages;
  final Alcohol? alcohol;
  final String? date;
  final String? firebaseUid;
  final bool? completed;


  Day({
    this.water,
    this.diet,
    this.insideWorkout,
    this.outsideWorkout,
    this.pages,
    this.alcohol,
    this.date,
    this.firebaseUid,
    this.completed,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      water: json['water'] != null ? Water.fromJson(json['water']) : null,
      diet: json['diet'] != null ? Diet.fromJson(json['diet']) : null,
      insideWorkout: json['inside_workout'] != null ? InsideWorkout.fromJson(json['inside_workout']) : null,
      outsideWorkout: json['outside_workout'] != null ? OutsideWorkout.fromJson(json['outside_workout']) : null,
      pages: json['pages'] != null ? TenPages.fromJson(json['pages']) : null,
      alcohol: json['alcohol'] != null ? Alcohol.fromJson(json['alcohol']) : null,
      date: json['date'],
      firebaseUid: json['firebase_uid'],
      completed: json['completed'],
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
