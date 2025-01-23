// lib/features/gallery/presentation/bloc/gallery_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seventy_five_hard/features/tracking/domain/entities/progress_photo.dart';
import '../../domain/repositories/gallery_repository.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GalleryRepository repository;

  GalleryBloc({required this.repository}) : super(GalleryInitial()) {
    on<LoadPhotos>(_onLoadPhotos);
    on<UploadPhoto>(_onUploadPhoto);
    on<DeletePhoto>(_onDeletePhoto);
    on<UpdatePhotoMetadata>(_onUpdatePhotoMetadata);
  }

  Future<void> _onLoadPhotos(LoadPhotos event, Emitter<GalleryState> emit) async {
    try {
      emit(GalleryLoading());
      final result = await repository.getPhotos();
      result.fold(
        (failure) => emit(GalleryError(failure.message)),
        (photos) => emit(GalleryLoaded(photos)),
      );
    } catch (e) {
      emit(GalleryError(e.toString()));
    }
  }

  Future<void> _onUploadPhoto(UploadPhoto event, Emitter<GalleryState> emit) async {
    try {
      emit(GalleryUploading());
      final uploadResult = await repository.uploadPhoto(event.photo, event.metadata);
      await uploadResult.fold(
        (failure) async => emit(GalleryError(failure.message)),
        (_) async {
          final photosResult = await repository.getPhotos();
          photosResult.fold(
            (failure) => emit(GalleryError(failure.message)),
            (photos) => emit(GalleryLoaded(photos)),
          );
        },
      );
    } catch (e) {
      emit(GalleryError(e.toString()));
    }
  }

  Future<void> _onDeletePhoto(DeletePhoto event, Emitter<GalleryState> emit) async {
    try {
      final deleteResult = await repository.deletePhoto(event.photoId);
      await deleteResult.fold(
        (failure) async => emit(GalleryError(failure.message)),
        (_) async {
          final photosResult = await repository.getPhotos();
          photosResult.fold(
            (failure) => emit(GalleryError(failure.message)),
            (photos) => emit(GalleryLoaded(photos)),
          );
        },
      );
    } catch (e) {
      emit(GalleryError(e.toString()));
    }
  }

  Future<void> _onUpdatePhotoMetadata(UpdatePhotoMetadata event, Emitter<GalleryState> emit) async {
    try {
      final updateResult = await repository.updatePhotoMetadata(event.photoId, event.metadata);
      await updateResult.fold(
        (failure) async => emit(GalleryError(failure.message)),
        (_) async {
          final photosResult = await repository.getPhotos();
          photosResult.fold(
            (failure) => emit(GalleryError(failure.message)),
            (photos) => emit(GalleryLoaded(photos)),
          );
        },
      );
    } catch (e) {
      emit(GalleryError(e.toString()));
    }
  }
}