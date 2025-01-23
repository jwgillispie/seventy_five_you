//lib/features/auth/presentation/widgets/signup_progress_indicator.dart

import 'package:flutter/material.dart';
import '../../../../../core/themes/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SignupProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(
            totalSteps,
            (index) => Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: index < currentStep 
                      ? SFColors.primary 
                      : SFColors.neutral.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Step $currentStep of $totalSteps',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: SFColors.textSecondary,
          ),
        ),
      ],
    );
  }
}