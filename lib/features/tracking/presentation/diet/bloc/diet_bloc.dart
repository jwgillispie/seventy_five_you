// lib/features/tracking/presentation/diet/bloc/diet_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/diet_tracking_model.dart';

part 'diet_event.dart';
part 'diet_state.dart';

class DietBloc extends Bloc<DietEvent, DietState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DietBloc() : super(DietInitial()) {
    on<FetchDietData>(_onFetchDietData);
    on<SubmitMeal>(_onSubmitMeal);
  }

  Future<void> _onFetchDietData(FetchDietData event, Emitter<DietState> emit) async {
    emit(DietLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user.uid}/${event.date}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Day day = Day.fromJson(json.decode(response.body));
        emit(DietLoaded(day.diet!));
      } else {
        emit(DietError('Failed to fetch diet data'));
      }
    } catch (e) {
      emit(DietError(e.toString()));
    }
  }

  Future<void> _onSubmitMeal(SubmitMeal event, Emitter<DietState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final dietData = event.diet.toJson();
      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user.uid}/${event.date}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'diet': dietData}),
      );

      if (response.statusCode == 200) {
        emit(DietSuccess());
        add(FetchDietData(event.date));
      } else {
        emit(DietError('Failed to update diet'));
      }
    } catch (e) {
      emit(DietError(e.toString()));
    }
  }
}