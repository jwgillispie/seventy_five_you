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
        : 'assets/images/library.jpg'; // Path for light theme image

    return Scaffold(
      appBar: AppBar(
          title: const Text('Ten Pages'),
          backgroundColor: Theme.of(context).primaryColor),
      body: Container(
        // decoration: BoxDecoration(
        //   // image: DecorationImage(
        //   //   image: AssetImage(backgroundImage),
        //   //   fit: BoxFit.cover,
        //   // ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      hintText: 'Share your thoughts on the pages you read...',
                      hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(150)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.5),
                      prefixIcon: Icon(Icons.book,
                          color: Theme.of(context).primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String summary = _summaryController.text;
                      print('User summary: $summary');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.2,
                        vertical: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
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
