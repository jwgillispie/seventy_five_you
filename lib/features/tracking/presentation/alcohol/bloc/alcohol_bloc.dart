// lib/features/tracking/presentation/alcohol/bloc/alcohol_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';
import 'package:seventy_five_hard/features/tracking/data/models/alcohol_tracking_model.dart';
import 'package:seventy_five_hard/features/tracking/data/services/day_service.dart';
import 'package:seventy_five_hard/features/tracking/presentation/alcohol/bloc/alcohol_event.dart';
import 'package:seventy_five_hard/features/tracking/presentation/alcohol/bloc/alcohol_state.dart';

class AlcoholBloc extends Bloc<AlcoholEvent, AlcoholState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DayService _dayService = DayService();

  AlcoholBloc() : super(AlcoholInitial()) {
    on<FetchAlcoholData>(_onFetchAlcoholData);
    on<UpdateAlcoholData>(_onUpdateAlcoholData);
  }

  Future<void> _onFetchAlcoholData(FetchAlcoholData event, Emitter<AlcoholState> emit) async {
    emit(AlcoholLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(AlcoholError('User not authenticated'));
        return;
      }

      final day = await _dayService.getDayByDate(event.date);
      
      if (day != null && day.alcohol != null) {
        emit(AlcoholLoaded(day.alcohol!));
      } else {
        // Initialize an empty alcohol model
        final emptyAlcohol = AlcoholTrackingModel(
          date: event.date,
          firebaseUid: user.uid,
          completed: false,
          difficulty: 5,
        );
        
        emit(AlcoholEmpty());
      }
    } catch (e) {
      emit(AlcoholError(e.toString()));
    }
  }

  Future<void> _onUpdateAlcoholData(UpdateAlcoholData event, Emitter<AlcoholState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(AlcoholError('User not authenticated'));
        return;
      }

      // Create alcohol data
      final alcoholData = {
        'alcohol': {
          'date': event.date,
          'firebase_uid': user.uid,
          'completed': event.avoidedAlcohol,
          'difficulty': event.difficulty,
        }
      };

      // Update the day record
      await _dayService.updateDay(event.date, alcoholData);

      emit(AlcoholSuccess());
      add(FetchAlcoholData(event.date));
    } catch (e) {
      emit(AlcoholError(e.toString()));
    }
  }
}