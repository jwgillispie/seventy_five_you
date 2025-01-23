abstract class WaterEvent {}

class FetchWaterData extends WaterEvent {
  final String date;
  FetchWaterData(this.date);
}

class UpdateWaterData extends WaterEvent {
  final String date;
  final int ouncesDrunk;
  final int peeCount;

  UpdateWaterData({
    required this.date,
    required this.ouncesDrunk,
    required this.peeCount,
  });
}
