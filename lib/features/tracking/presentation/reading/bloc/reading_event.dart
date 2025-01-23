
// lib/features/tracking/presentation/reading/bloc/reading_event.dart
part of 'reading_bloc.dart';

@immutable
abstract class ReadingEvent {}

class FetchReadingData extends ReadingEvent {
  final String date;
  FetchReadingData(this.date);
}

class UpdateReadingProgress extends ReadingEvent {
  final String date;
  final String bookTitle;
  final String summary;
  final int pagesRead;

  UpdateReadingProgress({
    required this.date,
    required this.bookTitle,
    required this.summary,
    required this.pagesRead,
  });
}
