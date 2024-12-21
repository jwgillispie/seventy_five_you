import 'package:seventy_five_hard/features/presentation/models/alcohol_model.dart';
import 'package:seventy_five_hard/features/presentation/models/diet_model.dart';
// import 'package:seventy_five_hard/features/presentation/models/inside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/outside_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/second_workout_model.dart';
import 'package:seventy_five_hard/features/presentation/models/ten_pages_model.dart';
import 'package:seventy_five_hard/features/presentation/models/water_model.dart';

class Day {
  final String? challengeId;
  final String? date;
  final Diet? diet;
  final SecondWorkout? secondWorkout;
  final OutsideWorkout? outsideWorkout;
  final TenPages? pages;
  final Alcohol? alcohol;
  final Water? water;
  final bool? completed;


  Day({
    this.challengeId,
    this.date,
    this.diet,
    this.secondWorkout,
    this.outsideWorkout,
    this.pages,
    this.alcohol,
    this.water,
    this.completed,
  });


  // Factory constructor for creating a Day object from JSON
  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      date: json['date'],
      challengeId: json['challenge_id'],
      diet: json['diet'] != null ? Diet.fromJson(json['diet']) : null,
      secondWorkout: json['second_workout'] != null ? SecondWorkout.fromJson(json['second_workout']) : null,
      outsideWorkout: json['outside_workout'] != null ? OutsideWorkout.fromJson(json['outside_workout']) : null,
      pages: json['pages'] != null ? TenPages.fromJson(json['pages']) : null,
      alcohol: json['alcohol'] != null ? Alcohol.fromJson(json['alcohol']) : null,
      water: json['water'] != null ? Water.fromJson(json['water']) : null,
      completed: json['completed'],
    );
  }


  // Convert Day object to JSON  
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'challenge_id': challengeId,
      'diet': diet?.toJson(),
      'outside_workout': outsideWorkout?.toJson(),
      'second_workout': secondWorkout?.toJson(),
      'alcohol': alcohol?.toJson(),
      'pages': pages?.toJson(),
      'water': water?.toJson(),
      'completed': completed,
    };
  }
}
