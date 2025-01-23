abstract class AlcoholEvent {}

class FetchAlcoholData extends AlcoholEvent {
  final String date;
  FetchAlcoholData(this.date);
}

class UpdateAlcoholData extends AlcoholEvent {
  final String date;
  final bool avoidedAlcohol;
  final int difficulty;

  UpdateAlcoholData({
    required this.date,
    required this.avoidedAlcohol,
    required this.difficulty,
  });
}
