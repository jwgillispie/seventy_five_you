// lib/features/gallery/presentation/widgets/photo_grid.dart

import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/tracking/domain/entities/progress_photo.dart';
import 'photo_card.dart';

class PhotoGrid extends StatelessWidget {
  final List<ProgressPhoto> photos;

  const PhotoGrid({
    Key? key,
    required this.photos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return PhotoCard(photo: photos[index]);
      },
    );
  }
}
