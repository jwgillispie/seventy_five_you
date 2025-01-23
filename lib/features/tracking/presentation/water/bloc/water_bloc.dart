// lib/features/tracking/presentation/water/bloc/water_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'package:seventy_five_hard/features/tracking/presentation/water/bloc/water_event.dart';
import 'package:seventy_five_hard/features/tracking/presentation/water/bloc/water_state.dart';
import 'dart:convert';


class WaterBloc extends Bloc<WaterEvent, WaterState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  WaterBloc() : super(WaterInitial()) {
    on<FetchWaterData>(_onFetchWaterData);
    on<UpdateWaterData>(_onUpdateWaterData);
  }

  Future<void> _onFetchWaterData(FetchWaterData event, Emitter<WaterState> emit) async {
    emit(WaterLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) return;

final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user.uid}/${event.date}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Day day = Day.fromJson(json.decode(response.body));
        if (day.water != null) {
          emit(WaterLoaded(day.water!));
        } else {
          emit(WaterEmpty());
        }
      } else {
        emit(WaterError('Failed to fetch water data'));
      }
    } catch (e) {
      emit(WaterError(e.toString()));
    }
  }

  Future<void> _onUpdateWaterData(UpdateWaterData event, Emitter<WaterState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final waterData = {
        'water': {
          'date': event.date,
          'firebase_uid': user.uid,
          'completed': event.ouncesDrunk >= 128,
          'peeCount': event.peeCount,
          'ouncesDrunk': event.ouncesDrunk,
        }
      };

      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user.uid}/${event.date}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(waterData),
      );

      if (response.statusCode == 200) {
        emit(WaterSuccess());
        add(FetchWaterData(event.date));
      } else {
        emit(WaterError('Failed to update water intake'));
      }
    } catch (e) {
      emit(WaterError(e.toString()));
    }
  }
}




