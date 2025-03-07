// lib/features/tracking/presentation/workout/pages/workout_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';
import 'package:seventy_five_hard/features/tracking/presentation/workout/bloc/workout_bloc.dart';
import 'package:seventy_five_hard/features/tracking/presentation/workout/bloc/workout_event.dart';
import 'package:seventy_five_hard/features/tracking/presentation/workout/bloc/workout_state.dart';
import '../widgets/workout_form.dart';

class WorkoutPage extends StatefulWidget {
  final bool isOutside;

  const WorkoutPage({Key? key, required this.isOutside}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage>
    with SingleTickerProviderStateMixin {
  late WorkoutBloc _workoutBloc;
  late AnimationController _animationController;
  final DateTime today = DateTime.now();

  String _description = '';
  String _thoughts = '';
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _workoutBloc = WorkoutBloc();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
    _fetchWorkoutData();
  }

  @override
  void dispose() {
    _workoutBloc.close();
    _animationController.dispose();
    super.dispose();
  }

  void _fetchWorkoutData() {
    _workoutBloc.add(FetchWorkoutData(today.toString().substring(0, 10)));
  }

  void _updateWorkout() {
    if (_description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe your workout'),
          backgroundColor: SFColors.error,
        ),
      );
      return;
    }
    
    _workoutBloc.add(UpdateWorkoutData(
      date: today.toString().substring(0, 10),
      description: _description,
      thoughts: _thoughts,
      isOutside: widget.isOutside,
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
                child: BlocConsumer<WorkoutBloc, WorkoutState>(
                  bloc: _workoutBloc,
                  listener: (context, state) {
                    if (state is WorkoutSuccess) {
                      setState(() {
                        _isCompleted = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Workout saved successfully! 💪'),
                          backgroundColor: SFColors.primary,
                        ),
                      );
                    } else if (state is WorkoutError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: const Color(0xFFB23B3B),
                        ),
                      );
                    } else if (state is WorkoutLoaded) {
                      final workout = widget.isOutside 
                          ? state.outsideWorkout 
                          : state.insideWorkout;
                      setState(() {
                        _description = '';
                        _thoughts =  '';
                        _isCompleted = false;
                      });
                      // setState(() {
                      //   _description = workout.description ?? '';
                      //   _thoughts = workout.thoughts ?? '';
                      //   _isCompleted = workout.completed ?? false;
                      // });
                    }
                  },
                  builder: (context, state) {
                    if (state is WorkoutLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _buildContent();
                  },
                ),
              )
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isOutside ? 'Outside Workout' : 'Inside Workout',
                style: GoogleFonts.orbitron(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: SFColors.surface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isOutside
                    ? 'Get some fresh air!'
                    : 'Time to get moving!',
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
              widget.isOutside ? Icons.directions_run : Icons.fitness_center,
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
          WorkoutForm(
            description: _description,
            thoughts: _thoughts,
            onDescriptionChanged: (value) {
              setState(() => _description = value);
            },
            onThoughtsChanged: (value) {
              setState(() => _thoughts = value);
            },
          ),
          const SizedBox(height: 30),

          // Complete button or completion message
          _isCompleted ? _buildCompletedMessage() : _buildCompleteButton(),
        ],
      ),
    );
  }

  Widget _buildCompleteButton() {
    return ElevatedButton(
      onPressed: _updateWorkout,
      style: ElevatedButton.styleFrom(
        backgroundColor: SFColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, size: 24),
          const SizedBox(width: 8),
          Text(
            'Complete Workout',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedMessage() {
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
            Icons.emoji_events,
            color: SFColors.surface,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'Workout Completed! 🎉',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SFColors.surface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Great job getting this ${widget.isOutside ? "outdoor" : "indoor"} workout done! Keep up the momentum.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: SFColors.surface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: SFColors.surface,
              side: const BorderSide(color: SFColors.surface),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Return to Home',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
