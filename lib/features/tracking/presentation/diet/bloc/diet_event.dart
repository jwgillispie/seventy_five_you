// lib/features/tracking/presentation/diet/bloc/diet_event.dart
part of 'diet_bloc.dart';

@immutable
abstract class DietEvent {}

class FetchDietData extends DietEvent {
  final String date;
  FetchDietData(this.date);
}

class SubmitMeal extends DietEvent {
  final DietTrackingModel diet;
  final String date;
  SubmitMeal({required this.diet, required this.date});
}
