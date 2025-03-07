// lib/features/tracking/presentation/workout/bloc/workout_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/inside_workout_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/outside_workout_model.dart';
import 'package:seventy_five_hard/features/tracking/data/services/day_service.dart';
import 'package:seventy_five_hard/features/tracking/presentation/workout/bloc/workout_event.dart';
import 'package:seventy_five_hard/features/tracking/presentation/workout/bloc/workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DayService _dayService = DayService();

  WorkoutBloc() : super(WorkoutInitial()) {
    on<FetchWorkoutData>(_onFetchWorkoutData);
    on<UpdateWorkoutData>(_onUpdateWorkoutData);
  }

  Future<void> _onFetchWorkoutData(FetchWorkoutData event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(WorkoutError('User not authenticated'));
        return;
      }

      final day = await _dayService.getDayByDate(event.date);
      
      if (day != null && day.insideWorkout != null && day.outsideWorkout != null) {
        emit(WorkoutLoaded(
          outsideWorkout: day.outsideWorkout!,
          insideWorkout: day.insideWorkout!,
        ));
      } else {
        // Initialize empty workout models if not found
        final outsideWorkout = OutsideWorkout(
          date: event.date,
          firebaseUid: user.uid,
          description: '',
          thoughts: '',
          completed: false,
          workoutType: '',
        );
        
        final insideWorkout = InsideWorkout(
          date: event.date,
          firebaseUid: user.uid,
          description: '',
          thoughts: '',
          completed: false,
          workoutType: '',
        );
        
        emit(WorkoutLoaded(
          outsideWorkout: outsideWorkout,
          insideWorkout: insideWorkout,
        ));
      }
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onUpdateWorkoutData(UpdateWorkoutData event, Emitter<WorkoutState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(WorkoutError('User not authenticated'));
        return;
      }

      // Create workout data based on whether it's inside or outside
      final workoutKey = event.isOutside ? 'outside_workout' : 'inside_workout';
      final workoutData = {
        workoutKey: {
          'date': event.date,
          'firebase_uid': user.uid,
          'description': event.description,
          'thoughts': event.thoughts,
          'completed': true,
          'workoutType': event.isOutside ? 'Outdoor' : 'Indoor',
        }
      };

      // Update the day record
      await _dayService.updateDay(event.date, workoutData);

      emit(WorkoutSuccess());
      add(FetchWorkoutData(event.date));
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }
}