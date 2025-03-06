// lib/features/tracking/presentation/water/pages/water_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';
import 'package:seventy_five_hard/features/tracking/presentation/water/bloc/water_event.dart';
import 'package:seventy_five_hard/features/tracking/presentation/water/bloc/water_state.dart';
import '../bloc/water_bloc.dart';
import '../widgets/water_bottle.dart';
import '../widgets/water_stats.dart';
import '../widgets/quick_add_buttons.dart';
import '../widgets/bathroom_counter.dart';
import 'dart:math';

class WaterPage extends StatefulWidget {
  const WaterPage({Key? key}) : super(key: key);

  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> with SingleTickerProviderStateMixin {
  late WaterBloc _waterBloc;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  final DateTime today = DateTime.now();
  int _ouncesDrunk = 0;
  int _peeCount = 0;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _waterBloc = WaterBloc();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(_waveController);
    
    _fetchWaterData();
  }

  @override
  void dispose() {
    _waterBloc.close();
    _waveController.dispose();
    super.dispose();
  }

  void _fetchWaterData() {
    _waterBloc.add(FetchWaterData(today.toString().substring(0, 10)));
  }

  void _updateWater() {
    _waterBloc.add(UpdateWaterData(
      date: today.toString().substring(0, 10),
      ouncesDrunk: _ouncesDrunk,
      peeCount: _peeCount,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [SFColors.surface, SFColors.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: BlocConsumer<WaterBloc, WaterState>(
                  bloc: _waterBloc,
                  listener: (context, state) {
                    if (state is WaterSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Water intake updated! 💧'),
                          backgroundColor: SFColors.primary,
                        ),
                      );
                    } else if (state is WaterError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: const Color(0xFFB23B3B),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is WaterLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WaterLoaded) {
                      _ouncesDrunk = state.water.ouncesDrunk ?? 0;
                      _peeCount = state.water.peeCount ?? 0;
                      return _buildContent();
                    }
                    return _buildContent();
                  },
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
        gradient: const LinearGradient(
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
                    'Hydration Station',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: SFColors.surface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stay hydrated!',
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
                child: const Icon(
                  Icons.water_drop,
                  color: SFColors.surface,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          WaterStats(
            ouncesDrunk: _ouncesDrunk,
            peeCount: _peeCount,
            streak: _streak,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          WaterBottle(
            ouncesDrunk: _ouncesDrunk,
            waveAnimation: _waveAnimation,
          ),
          const SizedBox(height: 24),
          QuickAddButtons(
            onAdd: (amount) {
              if (_ouncesDrunk + amount <= 128) {
                setState(() => _ouncesDrunk += amount);
                _updateWater();
              }
            },
          ),
          const SizedBox(height: 24),
          BathroomCounter(
            count: _peeCount,
            onIncrement: () {
              setState(() => _peeCount++);
              _updateWater();
            },
            onDecrement: () {
              if (_peeCount > 0) {
                setState(() => _peeCount--);
                _updateWater();
              }
            },
          ),
          if (_ouncesDrunk >= 128) ...[
            const SizedBox(height: 24),
            _buildCompletionCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildCompletionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [SFColors.primary, SFColors.secondary],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: SFColors.primary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.celebration,
            color: SFColors.surface,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'Daily Water Goal Achieved! 🎉',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SFColors.surface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re staying hydrated and crushing your goals!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: SFColors.surface.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
