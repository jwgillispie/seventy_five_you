
// lib/features/tracking/presentation/water/widgets/water_stats.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';

class WaterStats extends StatelessWidget {
  final int ouncesDrunk;
  final int peeCount;
  final int streak;

  const WaterStats({
    Key? key,
    required this.ouncesDrunk,
    required this.peeCount,
    required this.streak,
  }) : super(key: key);

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(
            icon: Icons.water_drop,
            value: '$ouncesDrunk oz',
            label: 'Consumed',
          ),
          _buildStat(
            icon: Icons.wc,
            value: peeCount.toString(),
            label: 'Breaks',
          ),
          _buildStat(
            icon: Icons.local_fire_department,
            value: '$streak days',
            label: 'Streak',
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: SFColors.tertiary),
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
            fontSize: 12,
            color: SFColors.textSecondary,
          ),
        ),
      ],
    );
  }
}