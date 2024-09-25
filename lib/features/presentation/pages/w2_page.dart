import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutTwoPage extends StatefulWidget {
  const WorkoutTwoPage({Key? key}) : super(key: key);

  @override
  State<WorkoutTwoPage> createState() => _WorkoutTwoPageState();
}

class _WorkoutTwoPageState extends State<WorkoutTwoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout 2',
          style: GoogleFonts.lato(),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).primaryColor),
                      child: Column(children: [
                        Text(
                          'Workout ',
                          style: GoogleFonts.lato(fontSize: 20),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Enter your workout description',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ])),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      // Handle workout description submission
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text('Submit Workout'),
                  ),
                  const SizedBox(height: 20),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).primaryColor),
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
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your thoughts or feelings',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      // Handle thoughts/feelings submission
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
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
