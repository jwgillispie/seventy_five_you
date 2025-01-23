
// lib/features/tracking/presentation/water/widgets/quick_add_buttons.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';

class QuickAddButtons extends StatelessWidget {
  final ValueChanged<int> onAdd;

  const QuickAddButtons({
    Key? key,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(8),
        _buildButton(16),
        _buildButton(32),
      ],
    );
  }

  Widget _buildButton(int amount) {
    return GestureDetector(
      onTap: () => onAdd(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [SFColors.neutral, SFColors.tertiary],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: SFColors.tertiary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.water_drop, color: SFColors.surface),
            const SizedBox(width: 8),
            Text(
              '$amount oz',
              style: GoogleFonts.inter(
                color: SFColors.surface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
