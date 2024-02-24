import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';

class WorkoutOnePage extends StatefulWidget {
  const WorkoutOnePage({Key? key}) : super(key: key);

  @override
  State<WorkoutOnePage> createState() => _WorkoutOnePageState();
}

class _WorkoutOnePageState extends State<WorkoutOnePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Workout 1'),
          backgroundColor: Theme.of(context).colorScheme.secondary),
      body: Stack(
        children: [
          // Background image or scene
          Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/images/outside_workout_dark.jpg'
                : 'assets/images/outside_workout_light.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Journal entry form
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description of the Workout',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontSize: 20),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter your workout description',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Thoughts/Feelings',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20),  
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter your thoughts or feelings',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
