
// lib/features/tracking/presentation/reading/bloc/reading_state.dart
part of 'reading_bloc.dart';

@immutable
abstract class ReadingState {}

class ReadingInitial extends ReadingState {}
class ReadingLoading extends ReadingState {}
class ReadingSuccess extends ReadingState {}
class ReadingEmpty extends ReadingState {}
class ReadingLoaded extends ReadingState {
  final ReadingTrackingModel reading;
  ReadingLoaded(this.reading);
}
class ReadingError extends ReadingState {
  final String message;
  ReadingError(this.message);
}