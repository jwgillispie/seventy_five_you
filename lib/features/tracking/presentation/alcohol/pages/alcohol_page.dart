// lib/features/tracking/presentation/alcohol/pages/alcohol_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';
import 'package:seventy_five_hard/features/tracking/presentation/alcohol/bloc/alcohol_bloc.dart';
import 'package:seventy_five_hard/features/tracking/presentation/alcohol/bloc/alcohol_event.dart';
import 'package:seventy_five_hard/features/tracking/presentation/alcohol/bloc/alcohol_state.dart';

class AlcoholPage extends StatefulWidget {
  const AlcoholPage({Key? key}) : super(key: key);

  @override
  State<AlcoholPage> createState() => _AlcoholPageState();
}

class _AlcoholPageState extends State<AlcoholPage> with SingleTickerProviderStateMixin {
  late AlcoholBloc _alcoholBloc;
  late AnimationController _animationController;
  final DateTime today = DateTime.now();
  bool _avoidedAlcohol = false;
  double _difficulty = 5.0;

  @override
  void initState() {
    super.initState();
    _alcoholBloc = AlcoholBloc();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
    _fetchAlcoholData();
  }

  @override
  void dispose() {
    _alcoholBloc.close();
    _animationController.dispose();
    super.dispose();
  }

  void _fetchAlcoholData() {
    _alcoholBloc.add(FetchAlcoholData(today.toString().substring(0, 10)));
  }

  void _updateAlcohol() {
    _alcoholBloc.add(UpdateAlcoholData(
      date: today.toString().substring(0, 10),
      avoidedAlcohol: _avoidedAlcohol,
      difficulty: _difficulty.toInt(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                child: BlocConsumer<AlcoholBloc, AlcoholState>(
                  bloc: _alcoholBloc,
                  listener: (context, state) {
                    if (state is AlcoholSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_avoidedAlcohol ? 'Great job staying alcohol-free! 🎉' : 'Progress updated!'),
                          backgroundColor: SFColors.primary,
                        ),
                      );
                    } else if (state is AlcoholError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Color(0xFFB23B3B),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AlcoholLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AlcoholLoaded) {
                      _avoidedAlcohol = state.alcohol.completed ?? false;
                      _difficulty = state.alcohol.difficulty?.toDouble() ?? 5.0;
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alcohol Free',
                style: GoogleFonts.orbitron(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: SFColors.surface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Stay strong!',
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
              Icons.no_drinks,
              color: SFColors.surface,
              size: 24,
            ),
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
          _buildAlcoholSwitch(),
          if (_avoidedAlcohol) ...[
            const SizedBox(height: 24),
            _buildDifficultySlider(),
          ],
          const SizedBox(height: 24),
          _buildMotivationalCard(),
        ],
      ),
    );
  }

  Widget _buildAlcoholSwitch() {
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
            'Daily Check-in',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SFColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stayed Alcohol-Free Today?',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: SFColors.textPrimary,
                ),
              ),
              Switch(
                value: _avoidedAlcohol,
                onChanged: (value) {
                  setState(() => _avoidedAlcohol = value);
                  _updateAlcohol();
                },
                activeColor: SFColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySlider() {
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
            'How Challenging Was It?',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SFColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Slider(
            value: _difficulty,
            min: 0,
            max: 10,
            divisions: 10,
            label: _difficulty.round().toString(),
            onChanged: (value) {
              setState(() => _difficulty = value);
              _updateAlcohol();
            },
            activeColor: SFColors.primary,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Easy', style: TextStyle(color: SFColors.textSecondary)),
              Text('Hard', style: TextStyle(color: SFColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _avoidedAlcohol
              ? [SFColors.primary, SFColors.secondary]
              : [SFColors.neutral, SFColors.tertiary],
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
          Icon(
            _avoidedAlcohol ? Icons.celebration : Icons.psychology,
            color: SFColors.surface,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            _avoidedAlcohol
                ? 'You\'re Crushing It! 💪'
                : 'Tomorrow Is A New Day 🌅',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SFColors.surface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _avoidedAlcohol
                ? 'Keep up the amazing work! Every day alcohol-free is a victory.'
                : 'Stay focused on your goals. You\'ve got this!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: SFColors.surface,
            ),
          ),
        ],
      ),
    );
  }
}

