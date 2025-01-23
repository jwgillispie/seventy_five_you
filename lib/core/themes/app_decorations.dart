import 'package:flutter/material.dart';
import 'app_colors.dart';
class SFDecorations {
  static BoxDecoration get whiteContainerShadow => BoxDecoration(
    color: SFColors.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: SFColors.neutral.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  static BoxDecoration get gradientContainer => BoxDecoration(
    gradient: const LinearGradient(
      colors: SFColors.primaryGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: SFColors.primary.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: SFColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: SFColors.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: SFColors.neutral.withOpacity(0.08),
        spreadRadius: 1,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}