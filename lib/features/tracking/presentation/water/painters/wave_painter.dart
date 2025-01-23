// lib/features/tracking/presentation/water/painters/wave_painter.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:seventy_five_hard/core/themes/app_colors.dart';

class WavePainter extends CustomPainter {
  final double progress;
  final double wavePhase;

  WavePainter({
    required this.progress,
    required this.wavePhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          SFColors.tertiary.withOpacity(0.6),
          SFColors.tertiary,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final baseHeight = size.height * (1 - progress);
    final amplitude = 10.0; // Wave height
    final frequency = 2.0; // Number of waves
    
    // Start point
    path.moveTo(0, size.height);
    path.lineTo(0, baseHeight);

    // Draw the wave
    for (var x = 0.0; x <= size.width; x++) {
      final y = baseHeight + 
          sin((wavePhase + (x / size.width) * 2 * pi) * frequency) * amplitude;
      path.lineTo(x, y);
    }

    // Complete the path
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) =>
      progress != oldDelegate.progress || wavePhase != oldDelegate.wavePhase;
}