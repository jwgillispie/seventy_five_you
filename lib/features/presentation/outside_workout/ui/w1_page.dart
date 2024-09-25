import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventy_five_hard/features/presentation/outside_workout/bloc/outside_workout_bloc.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutOnePage extends StatefulWidget {
  const WorkoutOnePage({Key? key}) : super(key: key);

  @override
  State<WorkoutOnePage> createState() => _WorkoutOnePageState();
}

class _WorkoutOnePageState extends State<WorkoutOnePage> {
  final TextEditingController _workoutDescriptionController = TextEditingController();
  final TextEditingController _reflectionController = TextEditingController();
  late OutsideWorkoutBloc outsideWorkoutBloc  = OutsideWorkoutBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _workoutDescriptionController.dispose();
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OutsideWorkoutBloc, OutsideWorkoutState>(
      bloc: outsideWorkoutBloc,
      listener: (context, state) {
        // Handle state changes if necessary
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Workout 1',
              style: GoogleFonts.lato(),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Column(children: [
                      Text(
                        'Workout',
                        style: GoogleFonts.lato(fontSize: 20),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: _workoutDescriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your workout description',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle workout description submission
                      outsideWorkoutBloc.add(OutsideWorkoutDescriptionSubmittedEvent(description: _workoutDescriptionController.text));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text('Submit Workout'),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Reflection',
                          style: GoogleFonts.lato(fontSize: 20),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: _reflectionController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your thoughts or feelings',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle thoughts/feelings submission
                      // You might want to create and dispatch a separate event for this
                      outsideWorkoutBloc.add(OutsideWorkoutThoughtsAndFeelingsSubmittedEvent(
                          thoughtsAndFeelings: _reflectionController.text));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text('Submit Thoughts'),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const NavBar(),
        );
      },
    );
  }
}
