//lib/features/auth/presentation/widgets/signup_validation_dialog.dart

import 'package:flutter/material.dart';
import '../../../../../core/themes/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupValidationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const SignupValidationDialog({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SFColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: SFColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Are you ready?',
              style: GoogleFonts.orbitron(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: SFColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '75 Hard is a challenging commitment. Make sure you\'re ready to give it your all for the next 75 days.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: SFColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
                    child: Text(
                      'Not Yet',
                      style: GoogleFonts.inter(
                        color: SFColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SFColors.primary,
                      foregroundColor: SFColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'I\'m Ready',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}