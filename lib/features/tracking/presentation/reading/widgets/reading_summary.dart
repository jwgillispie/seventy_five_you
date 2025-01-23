
// lib/features/tracking/presentation/reading/widgets/reading_summary.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';
import '../../../../../themes.dart';

class ReadingSummary extends StatelessWidget {
  final String bookTitle;
  final String summary;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onSummaryChanged;

  const ReadingSummary({
    Key? key,
    required this.bookTitle,
    required this.summary,
    required this.onTitleChanged,
    required this.onSummaryChanged,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reading Notes',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SFColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: TextEditingController(text: bookTitle),
            onChanged: onTitleChanged,
            decoration: InputDecoration(
              labelText: 'Book Title',
              filled: true,
              fillColor: SFColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: TextEditingController(text: summary),
            onChanged: onSummaryChanged,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Key Takeaways',
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
    );
  }
}