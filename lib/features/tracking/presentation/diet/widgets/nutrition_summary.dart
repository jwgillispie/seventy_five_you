// lib/features/tracking/presentation/diet/widgets/nutrition_summary.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';

class NutritionSummary extends StatelessWidget {
  const NutritionSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SFColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: SFColors.neutral.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Nutrition Summary',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SFColors.neutral,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNutrientItem('Protein', '75g', Icons.fitness_center),
              _buildNutrientItem('Carbs', '200g', Icons.grain),
              _buildNutrientItem('Fats', '55g', Icons.opacity),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: SFColors.neutral),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: SFColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: SFColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
