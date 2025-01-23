//lib/features/tracking/presentation/bloc/tracking_event.dart


import 'package:equatable/equatable.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object> get props => [];
}

class WaterTrackingUpdated extends TrackingEvent {
  final int peeCount;
  final int ouncesDrunk;
  final bool completed;

  const WaterTrackingUpdated({
    required this.peeCount,
    required this.ouncesDrunk,
    required this.completed,
  });

  @override
  List<Object> get props => [peeCount, ouncesDrunk, completed];
}

class WorkoutTrackingUpdated extends TrackingEvent {
  final String type;
  final String description;
  final String thoughts;
  final bool isOutdoor;
  final Duration duration;
  final int intensity;
  final bool completed;

  const WorkoutTrackingUpdated({
    required this.type,
    required this.description,
    required this.thoughts,
    required this.isOutdoor,
    required this.duration,
    required this.intensity,
    required this.completed,
  });

  @override
  List<Object> get props => [
    type,
    description,
    thoughts,
    isOutdoor,
    duration,
    intensity,
    completed,
  ];
}