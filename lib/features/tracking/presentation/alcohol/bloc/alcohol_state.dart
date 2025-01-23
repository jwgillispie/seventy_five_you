import 'package:seventy_five_hard/features/tracking/data/models/alcohol_tracking_model.dart';

abstract class AlcoholState {}

class AlcoholInitial extends AlcoholState {}
class AlcoholLoading extends AlcoholState {}
class AlcoholSuccess extends AlcoholState {}
class AlcoholEmpty extends AlcoholState {}
class AlcoholLoaded extends AlcoholState {
  final AlcoholTrackingModel alcohol;
  AlcoholLoaded(this.alcohol);
}
class AlcoholError extends AlcoholState {
  final String message;
  AlcoholError(this.message);
}