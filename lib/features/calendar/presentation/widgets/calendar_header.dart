
// lib/features/calendar/presentation/widgets/calendar_header.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../themes.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [SFColors.neutral, SFColors.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: SFColors.neutral.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress Calendar',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: SFColors.surface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track Your Journey',
                    style: GoogleFonts.inter(
                      color: SFColors.surface.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: SFColors.surface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: SFColors.surface,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}