import 'package:seventy_five_hard/features/tracking/data/models/water_tracking_model.dart';

abstract class WaterState {}

class WaterInitial extends WaterState {}
class WaterLoading extends WaterState {}
class WaterSuccess extends WaterState {}
class WaterEmpty extends WaterState {}
class WaterLoaded extends WaterState {
  final WaterTrackingModel water;
  WaterLoaded(this.water);
}
class WaterError extends WaterState {
  final String message;
  WaterError(this.message);
}