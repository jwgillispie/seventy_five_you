// lib/features/gallery/domain/repositories/gallery_repository.dart

import 'package:dartz/dartz.dart';
import 'package:seventy_five_hard/features/tracking/domain/entities/progress_photo.dart';
import '../../../../core/errors/failures.dart';

abstract class GalleryRepository {
  Future<Either<Failure, List<ProgressPhoto>>> getPhotos();
  Future<Either<Failure, void>> uploadPhoto(String photo, Map<String, dynamic> metadata);
  Future<Either<Failure, void>> deletePhoto(String photoId);
  Future<Either<Failure, void>> updatePhotoMetadata(String photoId, Map<String, dynamic> metadata);
}
