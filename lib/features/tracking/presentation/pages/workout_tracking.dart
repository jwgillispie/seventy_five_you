//lib/features/tracking/presentation/pages/workout_tracking_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/themes/app_colors.dart';
import '../bloc/tracking_bloc.dart';
import '../widgets/tracking_input_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutTrackingPage extends StatefulWidget {
  final bool isOutdoor;
  
  const WorkoutTrackingPage({
    Key? key,
    required this.isOutdoor,
  }) : super(key: key);

  @override
  State<WorkoutTrackingPage> createState() => _WorkoutTrackingPageState();
}

class _WorkoutTrackingPageState extends State<WorkoutTrackingPage> {
  final _descriptionController = TextEditingController();
  final _thoughtsController = TextEditingController();
  String _selectedWorkoutType = 'Strength';
  int _intensity = 5;
  Duration _duration = const Duration(minutes: 45);
  bool _isCompleted = false;

  final List<String> _workoutTypes = [
    'Strength',
    'Cardio',
    'HIIT',
    'Yoga',
    'Running',
    'Walking',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              AppColors.background,
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
                      _buildWorkoutTypeSelector(),
                      const SizedBox(height: 24),
                      _buildWorkoutDetails(),
                      const SizedBox(height: 24),
                      _buildIntensitySlider(),
                      const SizedBox(height: 24),
                      _buildDurationPicker(),
                      const SizedBox(height: 24),
                      _buildReflectionSection(),
                      const SizedBox(height: 36),
                      _buildCompleteButton(),
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
          colors: [AppColors.neutral, AppColors.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isOutdoor ? 'Outdoor Workout' : 'Indoor Workout',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.surface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Minimum 45 minutes',
                    style: GoogleFonts.inter(
                      color: AppColors.surface.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (widget.isOutdoor) _buildWeatherIndicator(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Type',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _workoutTypes.map((type) {
              final isSelected = type == _selectedWorkoutType;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedWorkoutType = type);
                  }
                },
                backgroundColor: AppColors.background,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.surface : AppColors.textPrimary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Description',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Describe your workout plan...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntensitySlider() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Intensity Level',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: _intensity.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: _intensity.toString(),
            onChanged: (value) {
              setState(() => _intensity = value.toInt());
            },
            activeColor: AppColors.primary,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Light', style: GoogleFonts.inter()),
              Text('Moderate', style: GoogleFonts.inter()),
              Text('Intense', style: GoogleFonts.inter()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDurationPicker() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Duration',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeButton(
                icon: Icons.remove,
                onPressed: () {
                  if (_duration.inMinutes > 45) {
                    setState(() {
                      _duration = Duration(minutes: _duration.inMinutes - 5);
                    });
                  }
                },
              ),
              const SizedBox(width: 20),
              Text(
                '${_duration.inMinutes} min',
                style: GoogleFonts.orbitron(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              _buildTimeButton(
                icon: Icons.add,
                onPressed: () {
                  setState(() {
                    _duration = Duration(minutes: _duration.inMinutes + 5);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildReflectionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reflection',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _thoughtsController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share your thoughts about the workout...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteButton() {
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is TrackingLoading
              ? null
              : _submitWorkout,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: state is TrackingLoading
              ? const CircularProgressIndicator()
              : Text(
                  'Complete Workout',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.surface,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildWeatherIndicator() {
    // In a real app, this would fetch actual weather data
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wb_sunny,
            color: Colors.yellow,
          ),
          const SizedBox(width: 8),
          Text(
            '72°F',
            style: GoogleFonts.inter(
              color: AppColors.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _submitWorkout() {
    context.read<TrackingBloc>().add(
      WorkoutTrackingUpdated(
        type: _selectedWorkoutType,
        description: _descriptionController.text,
        thoughts: _thoughtsController.text,
        isOutdoor: widget.isOutdoor,
        duration: _duration,
        intensity: _intensity,
        completed: true,
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _thoughtsController.dispose();
    super.dispose();
  }
}