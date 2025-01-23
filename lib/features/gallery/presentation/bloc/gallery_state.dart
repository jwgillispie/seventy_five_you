
// lib/features/gallery/presentation/bloc/gallery_state.dart
part of 'gallery_bloc.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();
  
  @override
  List<Object> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryUploading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<ProgressPhoto> photos;

  const GalleryLoaded(this.photos);

  @override
  List<Object> get props => [photos];
}

class GalleryError extends GalleryState {
  final String message;

  const GalleryError(this.message);

  @override
  List<Object> get props => [message];
}