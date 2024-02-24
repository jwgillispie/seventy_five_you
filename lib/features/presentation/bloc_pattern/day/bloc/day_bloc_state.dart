part of 'day_bloc.dart';

abstract class DayState {}

class DayInitial extends DayState {}

class DayLoading extends DayState {}

class DayLoaded extends DayState {
  final String date;
  DayLoaded({required this.date});
}

class DayOperationSuccess extends DayState {}

class DayOperationFailure extends DayState {
  final String error;
  DayOperationFailure({required this.error});
}
