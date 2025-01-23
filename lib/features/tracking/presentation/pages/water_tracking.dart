// lib/features/tracking/presentation/pages/water_tracking_page.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventy_five_hard/features/tracking/presentation/bloc/tracking_event.dart';
import 'package:seventy_five_hard/features/tracking/presentation/water/painters/wave_painter.dart';
import '../../../../../core/themes/app_colors.dart';
import '../bloc/tracking_bloc.dart';
import '../widgets/tracking_progress_card.dart';
import 'package:google_fonts/google_fonts.dart';

class WaterTrackingPage extends StatefulWidget {
  const WaterTrackingPage({Key? key}) : super(key: key);

  @override
  State<WaterTrackingPage> createState() => _WaterTrackingPageState();
}

class _WaterTrackingPageState extends State<WaterTrackingPage> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _waveAnimation;
  int _waterIntake = 0;
  int _peeCount = 0;
  static const int _targetIntake = 128; // 1 gallon in ounces

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _waveAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14,
    ).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              SFColors.surface,
              SFColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildWaterBottle(),
                      const SizedBox(height: 24),
                      _buildQuickActions(),
                      const SizedBox(height: 24),
                      _buildBathroomTracker(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [SFColors.neutral, SFColors.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
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
                    'Water Tracking',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: SFColors.surface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Daily Goal: 1 Gallon',
                    style: GoogleFonts.inter(
                      color: SFColors.surface.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              _buildProgressRing(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRing() {
    final progress = _waterIntake / _targetIntake;
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: SFColors.surface.withOpacity(0.2),
      ),
      child: Center(
        child: Text(
          '${(progress * 100).toInt()}%',
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: SFColors.surface,
          ),
        ),
      ),
    );
  }

  Widget _buildWaterBottle() {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return Container(
          height: 300,
          width: 150,
          decoration: BoxDecoration(
            color: SFColors.surface,
            borderRadius: BorderRadius.circular(75),
            boxShadow: [
              BoxShadow(
                color: SFColors.neutral.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(75),
            child: CustomPaint(
              painter: WavePainter(
                progress: _waterIntake / _targetIntake,
                wavePhase: _waveAnimation.value,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAddWaterButton(8, '8 oz'),
        _buildAddWaterButton(16, '16 oz'),
        _buildAddWaterButton(32, '32 oz'),
      ],
    );
  }

  Widget _buildAddWaterButton(int amount, String label) {
    return ElevatedButton(
      onPressed: () => _addWater(amount),
      style: ElevatedButton.styleFrom(
        backgroundColor: SFColors.neutral,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.water_drop, color: SFColors.surface),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: SFColors.surface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBathroomTracker() {
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
        children: [
          Text(
            'Bathroom Breaks',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SFColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBathroomButton(Icons.remove, () => _updatePeeCount(-1)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: SFColors.neutral.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '$_peeCount',
                  style: GoogleFonts.orbitron(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: SFColors.neutral,
                  ),
                ),
              ),
              _buildBathroomButton(Icons.add, () => _updatePeeCount(1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBathroomButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: SFColors.neutral,
        foregroundColor: SFColors.surface,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  void _addWater(int amount) {
    setState(() {
      _waterIntake = min(_waterIntake + amount, _targetIntake);
    });
    context.read<TrackingBloc>().add(
      WaterTrackingUpdated(
        peeCount: _peeCount,
        ouncesDrunk: _waterIntake,
        completed: _waterIntake >= _targetIntake,
      ),
    );
  }

  void _updatePeeCount(int delta) {
    setState(() {
      _peeCount = max(0, _peeCount + delta);
    });
    context.read<TrackingBloc>().add(
      WaterTrackingUpdated(
        peeCount: _peeCount,
        ouncesDrunk: _waterIntake,
        completed: _waterIntake >= _targetIntake,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}