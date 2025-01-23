// lib/features/tracking/presentation/workout/bloc/workout_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'package:seventy_five_hard/features/tracking/presentation/workout/bloc/workout_event.dart';
import 'package:seventy_five_hard/features/tracking/presentation/workout/bloc/workout_state.dart';
import 'dart:convert';


class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  WorkoutBloc() : super(WorkoutInitial()) {
    on<FetchWorkoutData>(_onFetchWorkoutData);
    on<UpdateWorkoutData>(_onUpdateWorkoutData);
  }

  Future<void> _onFetchWorkoutData(FetchWorkoutData event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user.uid}/${event.date}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final day = Day.fromJson(json.decode(response.body));
        emit(WorkoutLoaded(
          outsideWorkout: day.outsideWorkout!,
          insideWorkout: day.insideWorkout!,
        ));
      } else {
        emit(WorkoutError('Failed to fetch workout data'));
      }
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onUpdateWorkoutData(UpdateWorkoutData event, Emitter<WorkoutState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final workoutData = {
        event.isOutside ? 'outside_workout' : 'inside_workout': {
          'date': event.date,
          'firebase_uid': user.uid,
          'description': event.description,
          'thoughts': event.thoughts,
          'completed': true,
        }
      };

      final response = await http.put(
        Uri.parse('http://localhost:8000/day/${user.uid}/${event.date}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(workoutData),
      );

      if (response.statusCode == 200) {
        emit(WorkoutSuccess());
        add(FetchWorkoutData(event.date));
      } else {
        emit(WorkoutError('Failed to update workout'));
      }
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }
}



