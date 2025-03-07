// lib/features/tracking/presentation/water/bloc/water_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/water_tracking_model.dart';
import 'package:seventy_five_hard/features/tracking/data/services/day_service.dart';
import 'package:seventy_five_hard/features/tracking/presentation/water/bloc/water_event.dart';
import 'package:seventy_five_hard/features/tracking/presentation/water/bloc/water_state.dart';

class WaterBloc extends Bloc<WaterEvent, WaterState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DayService _dayService = DayService();

  WaterBloc() : super(WaterInitial()) {
    on<FetchWaterData>(_onFetchWaterData);
    on<UpdateWaterData>(_onUpdateWaterData);
  }

  Future<void> _onFetchWaterData(FetchWaterData event, Emitter<WaterState> emit) async {
    emit(WaterLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(WaterError('User not authenticated'));
        return;
      }

      final day = await _dayService.getDayByDate(event.date);
      
      if (day != null && day.water != null) {
        emit(WaterLoaded(day.water!));
      } else {
        emit(WaterEmpty());
      }
    } catch (e) {
      emit(WaterError(e.toString()));
    }
  }

  Future<void> _onUpdateWaterData(UpdateWaterData event, Emitter<WaterState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(WaterError('User not authenticated'));
        return;
      }

      // Create water tracking data
      final waterData = {
        'water': {
          'date': event.date,
          'firebase_uid': user.uid,
          'completed': event.ouncesDrunk >= 128, // 1 gallon = 128 oz
          'peeCount': event.peeCount,
          'ouncesDrunk': event.ouncesDrunk,
        }
      };

      // Update the day record
      await _dayService.updateDay(event.date, waterData);

      emit(WaterSuccess());
      add(FetchWaterData(event.date));
    } catch (e) {
      emit(WaterError(e.toString()));
    }
  }
}