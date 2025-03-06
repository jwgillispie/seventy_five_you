
// lib/features/calendar/presentation/widgets/day_details.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';
import 'package:seventy_five_hard/features/tracking/data/models/day_model.dart';

class DayDetails extends StatelessWidget {
  final Day day;

  const DayDetails({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (day.water != null) _buildObjectiveCard(
          title: 'Water Intake',
          icon: Icons.water_drop,
          content: [
            _buildObjectiveContent(
              icon: Icons.bathroom_outlined,
              label: 'Pee Count: ${day.water!.peeCount}',
              success: day.water!.peeCount > 5,
            ),
          ],
        ),
        if (day.diet != null) _buildObjectiveCard(
          title: 'Diet',
          icon: Icons.restaurant_menu,
          content: [
            _buildObjectiveContent(
              icon: Icons.breakfast_dining,
              label: 'Breakfast: ${day.diet!.breakfast?.join(", ") ?? "N/A"}',
            ),
            _buildObjectiveContent(
              icon: Icons.lunch_dining,
              label: 'Lunch: ${day.diet!.lunch?.join(", ") ?? "N/A"}',
            ),
            _buildObjectiveContent(
              icon: Icons.dinner_dining,
              label: 'Dinner: ${day.diet!.dinner?.join(", ") ?? "N/A"}',
            ),
            _buildObjectiveContent(
              icon: Icons.fastfood,
              label: 'Snacks: ${day.diet!.snacks?.join(", ") ?? "N/A"}',
            ),
          ],
        ),
        // Add other objectives as needed
      ],
    );
  }

  Widget _buildObjectiveCard({
    required String title,
    required IconData icon,
    required List<Widget> content,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: SFColors.neutral.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: SFColors.neutral),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.orbitron(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: SFColors.neutral,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildObjectiveContent({
    required IconData icon,
    required String label,
    bool success = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: success ? SFColors.primary : const Color(0xFFB23B3B),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: success ? SFColors.primary : const Color(0xFFB23B3B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}