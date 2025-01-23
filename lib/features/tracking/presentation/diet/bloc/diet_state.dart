// lib/features/tracking/presentation/diet/bloc/diet_state.dart
part of 'diet_bloc.dart';

@immutable
abstract class DietState {}

class DietInitial extends DietState {}
class DietLoading extends DietState {}
class DietSuccess extends DietState {}
class DietLoaded extends DietState {
  final DietTrackingModel diet;
  DietLoaded(this.diet);
}
class DietError extends DietState {
  final String message;
  DietError(this.message);
}
