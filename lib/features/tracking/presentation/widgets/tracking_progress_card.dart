// lib/features/tracking/presentation/widgets/tracking_progress_card.dart

import 'package:flutter/material.dart';
import '../../../../../core/themes/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackingProgressCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double progress;
  final String subtitle;
  final VoidCallback onTap;
  final bool isCompleted;

  const TrackingProgressCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.progress,
    required this.subtitle,
    required this.onTap,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCompleted 
              ? [SFColors.success, SFColors.success.withOpacity(0.8)]
              : [SFColors.neutral, SFColors.tertiary],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: SFColors.neutral.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: SFColors.surface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: SFColors.surface,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: SFColors.surface,
                    ),
                  ),
                ),
                if (isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: SFColors.surface,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: SFColors.surface.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(SFColors.surface),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: SFColors.surface.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}