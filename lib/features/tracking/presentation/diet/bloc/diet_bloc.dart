// lib/features/tracking/presentation/diet/bloc/diet_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/diet_tracking_model.dart';
import 'package:seventy_five_hard/features/tracking/data/services/day_service.dart';

part 'diet_event.dart';
part 'diet_state.dart';

class DietBloc extends Bloc<DietEvent, DietState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DayService _dayService = DayService();

  DietBloc() : super(DietInitial()) {
    on<FetchDietData>(_onFetchDietData);
    on<SubmitMeal>(_onSubmitMeal);
  }

  Future<void> _onFetchDietData(FetchDietData event, Emitter<DietState> emit) async {
    emit(DietLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(DietError('User not authenticated'));
        return;
      }

      final day = await _dayService.getDayByDate(event.date);
      
      if (day != null && day.diet != null) {
        emit(DietLoaded(day.diet!));
      } else {
        // Initialize an empty diet model
        final emptyDiet = DietTrackingModel(
          date: event.date,
          firebaseUid: user.uid,
          breakfast: [],
          lunch: [],
          dinner: [],
          snacks: [],
          completed: false,
        );
        
        // Create the empty diet entry
        final dietData = {
          'diet': emptyDiet.toJson(),
        };
        
        await _dayService.updateDay(event.date, dietData);
        emit(DietLoaded(emptyDiet));
      }
    } catch (e) {
      emit(DietError(e.toString()));
    }
  }

  Future<void> _onSubmitMeal(SubmitMeal event, Emitter<DietState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(DietError('User not authenticated'));
        return;
      }

      // Update with the diet data
      final dietData = {
        'diet': event.diet.toJson(),
      };

      // Update the day record
      await _dayService.updateDay(event.date, dietData);

      emit(DietSuccess());
      add(FetchDietData(event.date));
    } catch (e) {
      emit(DietError(e.toString()));
    }
  }
}