// lib/features/gallery/presentation/pages/gallery_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';
import '../bloc/gallery_bloc.dart';
import '../widgets/photo_grid.dart';
import '../widgets/upload_photo_button.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late GalleryBloc _galleryBloc;

  @override
  void initState() {
    super.initState();
    _galleryBloc = context.read<GalleryBloc>();
    _galleryBloc.add(LoadPhotos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [SFColors.surface, SFColors.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: BlocBuilder<GalleryBloc, GalleryState>(
                  builder: (context, state) {
                    if (state is GalleryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GalleryLoaded) {
                      return PhotoGrid(photos: state.photos);
                    } else if (state is GalleryError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: SFColors.error),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const UploadPhotoButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [SFColors.neutral, SFColors.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: SFColors.neutral.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Progress Gallery',
            style: GoogleFonts.orbitron(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: SFColors.surface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your transformation',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: SFColors.surface.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
