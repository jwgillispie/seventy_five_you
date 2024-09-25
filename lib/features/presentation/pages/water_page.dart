import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // If using SVG graphics
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  @override
  _WaterPageState createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  double _remainingWaterOunces = 128.0;
  int _bathroomCounter = 0;
  bool _showMotivation = false;

  void _updateWaterLevel(double newValue) {
    setState(() {
      _remainingWaterOunces = newValue;
      _showMotivation = newValue == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hydrating'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Water Level Slider
                RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    value: _remainingWaterOunces,
                    min: 0,
                    max: 128,
                    divisions: 128,
                    onChanged: _updateWaterLevel,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 20),
                // Water Gallon Representation
                Container(
                  height: 200,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: _remainingWaterOunces / 128.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            if (_showMotivation)
              Text(
                'Great job on staying hydrated!',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18),
              ),
            SizedBox(height: 20),
            // Pee Count
            Text(
              'Pee Count: $_bathroomCounter',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (_bathroomCounter > 0) {
                      setState(() => _bathroomCounter--);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() => _bathroomCounter++);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}


