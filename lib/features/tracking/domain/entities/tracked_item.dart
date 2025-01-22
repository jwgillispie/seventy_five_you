lib/features/tracking/domain/entities/tracked_item.dart

abstract class TrackedItem {
  final String id;
  final String date;
  final String firebaseUid;
  final bool completed;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const TrackedItem({
    required this.id,
    required this.date,
    required this.firebaseUid,
    required this.completed,
    required this.createdAt,
    this.updatedAt,
  });
}