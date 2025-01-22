
// lib/features/calendar/presentation/bloc/calendar_state.dart
part of 'calendar_bloc.dart';

@immutable
abstract class CalendarState {}

class CalendarInitial extends CalendarState {}
class CalendarLoading extends CalendarState {}
class CalendarLoaded extends CalendarState {
  final Day day;
  CalendarLoaded(this.day);
}
class CalendarEmpty extends CalendarState {}
class CalendarError extends CalendarState {
  final String message;
  CalendarError(this.message);
}