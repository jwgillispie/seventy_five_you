// lib/features/tracking/presentation/workout/pages/workout_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';
import 'package:seventy_five_hard/features/tracking/presentation/workout/bloc/workout_event.dart';
import 'package:seventy_five_hard/features/tracking/presentation/workout/bloc/workout_state.dart';
import '../bloc/workout_bloc.dart';
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
                    }
                  },
                  builder: (context, state) {
                    if (state is WorkoutLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WorkoutLoaded) {
                      if (widget.isOutside) {
                        _description = state.outsideWorkout.description!;
                        _thoughts = state.outsideWorkout.thoughts!;
                      } else {
                        _description = state.insideWorkout.description!;
                        _thoughts = state.insideWorkout.thoughts!;
                      }
                      return _buildContent();
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
              _updateWorkout();
            },
            onThoughtsChanged: (value) {
              setState(() => _thoughts = value);
              _updateWorkout();
            },
          ),
        ],
      ),
    );
  }
}
