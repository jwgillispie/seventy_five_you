// lib/features/calendar/presentation/bloc/calendar_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'dart:convert';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CalendarBloc() : super(CalendarInitial()) {
    on<FetchDayData>(_onFetchDayData);
  }

  Future<void> _onFetchDayData(FetchDayData event, Emitter<CalendarState> emit) async {
    try {
      emit(CalendarLoading());
      final user = _auth.currentUser;
      if (user == null) {
        emit(CalendarError("User not authenticated"));
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user.uid}/${event.date}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final day = Day.fromJson(json.decode(response.body));
        emit(CalendarLoaded(day));
      } else if (response.statusCode == 404) {
        emit(CalendarEmpty());
      } else {
        emit(CalendarError("Failed to fetch data"));
      }
    } catch (e) {
      emit(CalendarError(e.toString()));
    }
  }
}
