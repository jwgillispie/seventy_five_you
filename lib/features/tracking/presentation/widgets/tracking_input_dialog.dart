//lib/features/tracking/presentation/widgets/tracking_input_dialog.dart

import 'package:flutter/material.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../shared/widgets/app_button.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackingInputDialog extends StatelessWidget {
  final String title;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final bool isLoading;

  const TrackingInputDialog({
    Key? key,
    required this.title,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.onSubmit,
    this.isLoading = false,
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.neutral, AppColors.tertiary],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.surface,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              onPressed: onSubmit,
              label: 'Save',
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}