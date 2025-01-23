
// lib/features/tracking/presentation/alcohol/widgets/challenge_stats.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';

class ChallengeStats extends StatelessWidget {
  final int currentStreak;
  final int bestStreak;
  final int daysCompleted;

  const ChallengeStats({
    Key? key,
    required this.currentStreak,
    required this.bestStreak,
    required this.daysCompleted,
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
          _buildStatColumn(
            icon: Icons.local_fire_department,
            value: currentStreak.toString(),
            label: 'Current\nStreak',
            color: SFColors.primary,
          ),
          _buildStatColumn(
            icon: Icons.emoji_events,
            value: bestStreak.toString(),
            label: 'Best\nStreak',
            color: SFColors.secondary,
          ),
          _buildStatColumn(
            icon: Icons.calendar_today,
            value: daysCompleted.toString(),
            label: 'Days\nCompleted',
            color: SFColors.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: SFColors.textPrimary,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: SFColors.textSecondary,
          ),
        ),
      ],
    );
  }
}