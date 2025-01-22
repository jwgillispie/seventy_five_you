
// lib/features/calendar/presentation/bloc/calendar_event.dart
part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent {}

class FetchDayData extends CalendarEvent {
  final String date;
  FetchDayData(this.date);
}