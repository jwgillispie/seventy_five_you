
// lib/features/tracking/presentation/workout/widgets/workout_form.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';
import '../../../../../themes.dart';

class WorkoutForm extends StatelessWidget {
  final String description;
  final String thoughts;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onThoughtsChanged;

  const WorkoutForm({
    Key? key,
    required this.description,
    required this.thoughts,
    required this.onDescriptionChanged,
    required this.onThoughtsChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workout Details',
                style: GoogleFonts.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: SFColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: TextEditingController(text: description),
                onChanged: onDescriptionChanged,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'What did you do?',
                  filled: true,
                  fillColor: SFColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reflection',
                style: GoogleFonts.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: SFColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: TextEditingController(text: thoughts),
                onChanged: onThoughtsChanged,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'How did it feel?',
                  filled: true,
                  fillColor: SFColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}