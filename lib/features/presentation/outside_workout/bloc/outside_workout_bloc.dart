import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'outside_workout_event.dart';
part 'outside_workout_state.dart';

class OutsideWorkoutBloc extends Bloc<OutsideWorkoutEvent, OutsideWorkoutState> {
  OutsideWorkoutBloc() : super(OutsideWorkoutInitial()) {
    on<OutsideWorkoutDescriptionSubmittedEvent>  (descriptionSubmitted);
    on<OutsideWorkoutThoughtsAndFeelingsSubmittedEvent>  (thoughtsAndFeelingsSubmitted);


  }

  FutureOr<void> descriptionSubmitted(OutsideWorkoutDescriptionSubmittedEvent event, Emitter<OutsideWorkoutState> emit) {
  }

  FutureOr<void> thoughtsAndFeelingsSubmitted(OutsideWorkoutThoughtsAndFeelingsSubmittedEvent event, Emitter<OutsideWorkoutState> emit) {
  }
}
