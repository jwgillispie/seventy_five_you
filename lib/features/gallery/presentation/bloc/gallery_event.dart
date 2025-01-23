
// lib/features/gallery/presentation/bloc/gallery_event.dart
part of 'gallery_bloc.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object> get props => [];
}

class LoadPhotos extends GalleryEvent {}

class UploadPhoto extends GalleryEvent {
  final String photo;
  final Map<String, dynamic> metadata;

  const UploadPhoto(this.photo, this.metadata);

  @override
  List<Object> get props => [photo, metadata];
}

class DeletePhoto extends GalleryEvent {
  final String photoId;

  const DeletePhoto(this.photoId);

  @override
  List<Object> get props => [photoId];
}

class UpdatePhotoMetadata extends GalleryEvent {
  final String photoId;
  final Map<String, dynamic> metadata;

  const UpdatePhotoMetadata(this.photoId, this.metadata);

  @override
  List<Object> get props => [photoId, metadata];
}
