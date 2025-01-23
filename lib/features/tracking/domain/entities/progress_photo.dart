// lib/features/gallery/domain/entities/progress_photo.dart

class ProgressPhoto {
  final String id;
  final String userId;
  final String imageUrl;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  ProgressPhoto({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.timestamp,
    required this.metadata,
  });
}