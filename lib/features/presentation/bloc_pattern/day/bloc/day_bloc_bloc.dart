import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seventy_five_hard/features/presentation/bloc_pattern/day/bloc/day_bloc_state.dart';
part 'day_bloc_event.dart';
part 'day_bloc_bloc.dart'; 

class DayBloc extends Bloc<DayEvent, DayState> {
  final DayRepository dayRepository;

  DayBloc({required this.dayRepository}) : super(DayInitial()) {
    on<LoadDay>(_onLoadDay);
    on<CreateDay>(_onCreateDay);
    on<UpdateDay>(_onUpdateDay);
    on<DeleteDay>(_onDeleteDay);
  }

  Future<void> _onLoadDay(LoadDay event, Emitter<DayState> emit) async {
    try {
      emit(DayLoading());
      final day = await dayRepository.loadDay(event.date);
      emit(DayLoaded(day: day));
    } catch (e) {
      emit(DayOperationFailure(error: e.toString()));
    }
  }

  // Implement _onCreateDay, _onUpdateDay, and _onDeleteDay similarly
}
