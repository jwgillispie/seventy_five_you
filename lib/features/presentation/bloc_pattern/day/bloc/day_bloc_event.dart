part of 'day_bloc.dart';

abstract class DayEvent {}

class LoadDay extends DayEvent {
  final String date;
  LoadDay({required this.date});
}

class CreateDay extends DayEvent {
  final String date;
  CreateDay({required this.date});
}

