// lib/features/tracking/presentation/reading/bloc/reading_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/reading_tracking_model.dart';
import 'package:seventy_five_hard/features/tracking/data/services/day_service.dart';

part 'reading_event.dart';
part 'reading_state.dart';

class ReadingBloc extends Bloc<ReadingEvent, ReadingState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DayService _dayService = DayService();

  ReadingBloc() : super(ReadingInitial()) {
    on<FetchReadingData>(_onFetchReadingData);
    on<UpdateReadingProgress>(_onUpdateReadingProgress);
  }

  Future<void> _onFetchReadingData(FetchReadingData event, Emitter<ReadingState> emit) async {
    emit(ReadingLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(ReadingError('User not authenticated'));
        return;
      }

      final day = await _dayService.getDayByDate(event.date);
      
      if (day != null && day.pages != null) {
        emit(ReadingLoaded(day.pages!));
      } else {
        // Initialize an empty reading model
        final emptyReading = ReadingTrackingModel(
          date: event.date,
          firebaseUid: user.uid,
          completed: false,
          summary: '',
          bookTitle: '',
          pagesRead: 0
        );
        
        emit(ReadingEmpty());
      }
    } catch (e) {
      emit(ReadingError(e.toString()));
    }
  }

  Future<void> _onUpdateReadingProgress(UpdateReadingProgress event, Emitter<ReadingState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(ReadingError('User not authenticated'));
        return;
      }

      // Create reading data
      final readingData = {
        'pages': {
          'date': event.date,
          'firebase_uid': user.uid,
          'bookTitle': event.bookTitle,
          'summary': event.summary,
          'pagesRead': event.pagesRead,
          'completed': event.pagesRead >= 10, // 10 pages minimum
        }
      };

      // Update the day record
      await _dayService.updateDay(event.date, readingData);

      emit(ReadingSuccess());
      add(FetchReadingData(event.date));
    } catch (e) {
      emit(ReadingError(e.toString()));
    }
  }
}