// lib/features/tracking/presentation/reading/bloc/reading_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/reading_tracking_model.dart';


part 'reading_event.dart';
part 'reading_state.dart';

class ReadingBloc extends Bloc<ReadingEvent, ReadingState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ReadingBloc() : super(ReadingInitial()) {
    on<FetchReadingData>(_onFetchReadingData);
    on<UpdateReadingProgress>(_onUpdateReadingProgress);
  }

  Future<void> _onFetchReadingData(FetchReadingData event, Emitter<ReadingState> emit) async {
    emit(ReadingLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user.uid}/${event.date}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Day day = Day.fromJson(json.decode(response.body));
        if (day.pages != null) {
          emit(ReadingLoaded(day.pages!));
        } else {
          emit(ReadingEmpty());
        }
      } else {
        emit(ReadingError('Failed to fetch reading data'));
      }
    } catch (e) {
      emit(ReadingError(e.toString()));
    }
  }

  Future<void> _onUpdateReadingProgress(UpdateReadingProgress event, Emitter<ReadingState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final readingData = {
        'pages': {
          'date': event.date,
          'firebase_uid': user.uid,
          'bookTitle': event.bookTitle,
          'summary': event.summary,
          'pagesRead': event.pagesRead,
          'completed': event.pagesRead >= 10,
        }
      };

      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user.uid}/${event.date}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(readingData),
      );

      if (response.statusCode == 200) {
        emit(ReadingSuccess());
        add(FetchReadingData(event.date));
      } else {
        emit(ReadingError('Failed to update reading progress'));
      }
    } catch (e) {
      emit(ReadingError(e.toString()));
    }
  }
}
