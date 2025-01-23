
// lib/features/tracking/presentation/alcohol/widgets/achievement_card.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';

class AchievementCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isAchieved;

  const AchievementCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isAchieved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAchieved ? SFColors.primary.withOpacity(0.1) : SFColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAchieved ? SFColors.primary : SFColors.neutral.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isAchieved ? SFColors.primary : SFColors.textSecondary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isAchieved ? SFColors.primary : SFColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: SFColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isAchieved)
            Icon(
              Icons.check_circle,
              color: SFColors.primary,
              size: 24,
            ),
        ],
      ),
    );
  }
}