// lib/features/tracking/presentation/alcohol/bloc/alcohol_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'package:seventy_five_hard/features/tracking/presentation/alcohol/bloc/alcohol_event.dart';
import 'package:seventy_five_hard/features/tracking/presentation/alcohol/bloc/alcohol_state.dart';
import 'dart:convert';



class AlcoholBloc extends Bloc<AlcoholEvent, AlcoholState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AlcoholBloc() : super(AlcoholInitial()) {
    on<FetchAlcoholData>(_onFetchAlcoholData);
    on<UpdateAlcoholData>(_onUpdateAlcoholData);
  }

  Future<void> _onFetchAlcoholData(FetchAlcoholData event, Emitter<AlcoholState> emit) async {
    emit(AlcoholLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user.uid}/${event.date}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Day day = Day.fromJson(json.decode(response.body));
        if (day.alcohol != null) {
          emit(AlcoholLoaded(day.alcohol!));
        } else {
          emit(AlcoholEmpty());
        }
      } else {
        emit(AlcoholError('Failed to fetch alcohol data'));
      }
    } catch (e) {
      emit(AlcoholError(e.toString()));
    }
  }

  Future<void> _onUpdateAlcoholData(UpdateAlcoholData event, Emitter<AlcoholState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final alcoholData = {
        'alcohol': {
          'date': event.date,
          'firebase_uid': user.uid,
          'completed': event.avoidedAlcohol,
          'difficulty': event.difficulty,
        }
      };

      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user.uid}/${event.date}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(alcoholData),
      );

      if (response.statusCode == 200) {
        emit(AlcoholSuccess());
        add(FetchAlcoholData(event.date));
      } else {
        emit(AlcoholError('Failed to update alcohol status'));
      }
    } catch (e) {
      emit(AlcoholError(e.toString()));
    }
  }
}
