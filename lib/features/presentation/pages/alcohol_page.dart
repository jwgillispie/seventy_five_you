import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';

class AlcoholPage extends StatefulWidget {
  const AlcoholPage({Key? key}) : super(key: key);

  @override
  State<AlcoholPage> createState() => _AlcoholPageState();
}

class _AlcoholPageState extends State<AlcoholPage> {
  double _rating = 5.0;
  bool _avoidedAlcohol = false; // 0 for No, 1 for Yes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alcohol'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          // Image.asset(
          //   Theme.of(context).brightness == Brightness.dark
          //       ? 'assets/images/alcohol_dark.jpg'
          //       : 'assets/images/alcohol_light.jpg',
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          Container(
             // Semi-transparent overlay
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'How hard was it to avoid alcohol today?',
                    style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  Slider(
                    value: _rating,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (value) {
                      setState(() {
                        _rating = value;
                      });
                    },
                    label:
                        '${_rating.toInt()} : ${ratingToDifficulty(_rating)}',
                  ),
                  SwitchListTile(
                    title: Text('Did you avoid alcohol today?'),
                    value: _avoidedAlcohol,
                    onChanged: (bool value) {
                      setState(() {
                        _avoidedAlcohol = value;
                      });
                    },
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
