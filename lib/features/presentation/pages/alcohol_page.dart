import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';

class AlcoholPage extends StatefulWidget {
  const AlcoholPage({Key? key}) : super(key: key);

  @override
  State<AlcoholPage> createState() => _AlcoholPageState();
}

class _AlcoholPageState extends State<AlcoholPage> {
  double _rating = 5.0; // Initial rating value
  bool _drankAlcohol = false; // Initial value for whether alcohol was consumed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Alcohol'),
          backgroundColor: Theme.of(context).colorScheme.secondary),
      body: Stack(
        children: [
          // Background image or scene
          Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/images/alcohol_dark.jpg'
                : 'assets/images/alcohol_light.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Journal entry form
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'How hard was it to avoid alcohol today?',
                    style: TextStyle(fontSize: 20),
                  ),
                  Slider(
                    value: _rating,
                    min: 1,
                    max: 10,
                    divisions:
                        9, // Number of divisions between min and max values
                    onChanged: (value) {
                      setState(() {
                        _rating = value;
                      });
                    },
                    label: _rating
                        .toInt()
                        .toString(), // Display current rating as label
                  ),
                  Text(
                    '${_rating.toInt()} : ${ratingToDifficulty(_rating)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Did you avoid alcohol today?'),
                      const SizedBox(width: 10),
                      Checkbox(
                        value: _drankAlcohol,
                        onChanged: (value) {
                          setState(() {
                            _drankAlcohol = value!;
                          });
                        },
                      ),
                    ],
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

  String ratingToDifficulty(double rating) {
    if (rating < 3) {
      return 'Easy';
    } else if (rating < 7 && rating >= 3) {
      return 'Moderate';
    } else if (rating >= 7 && rating < 10) {
      return 'Hard';
    } else {
      return 'Impossible';
    }
  }
}
