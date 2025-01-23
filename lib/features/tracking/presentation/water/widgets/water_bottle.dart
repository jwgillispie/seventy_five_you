// lib/features/tracking/presentation/water/widgets/water_bottle.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/themes/app_colors.dart';
import '../painters/wave_painter.dart';

class WaterBottle extends StatelessWidget {
  final int ouncesDrunk;
  final Animation<double> waveAnimation;

  const WaterBottle({
    Key? key,
    required this.ouncesDrunk,
    required this.waveAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 120,
      decoration: BoxDecoration(
        color: SFColors.surface,
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: SFColors.tertiary.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: AnimatedBuilder(
              animation: waveAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: WavePainter(
                    progress: ouncesDrunk / 128,
                    wavePhase: waveAnimation.value,
                  ),
                );
              },
            ),
          ),
          Center(
            child: Text(
              '${((ouncesDrunk / 128) * 100).toInt()}%',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: SFColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}