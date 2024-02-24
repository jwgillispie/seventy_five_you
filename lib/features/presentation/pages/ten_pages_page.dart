import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';

class TenPagesPage extends StatefulWidget {
  const TenPagesPage({Key? key}) : super(key: key);

  @override
  State<TenPagesPage> createState() => _TenPagesPageState();
}

class _TenPagesPageState extends State<TenPagesPage> {
  final TextEditingController _summaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Determine the current theme
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    
    // Set the image based on the theme
    String backgroundImage = isDarkTheme
        ? 'assets/images/library_dark.jpg' // Path for dark theme image
        : 'assets/images/library.jpg';     // Path for light theme image

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ten Pages'),
        backgroundColor: Theme.of(context).colorScheme.secondary
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Summarize what you read in the 10 pages:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _summaryController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2.0,
                        color: Theme.of(context).colorScheme.secondary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter your summary here',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String summary = _summaryController.text;
                  print('User summary: $summary');
                },
                child:  Text('Submit', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }
}
