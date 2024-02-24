import 'package:flutter/material.dart';
import 'package:seventy_five_hard/features/presentation/widgets/nav_bar.dart';
class DietPage extends StatefulWidget {
  const DietPage({Key? key}) : super(key: key);

  @override
  DietPageState createState() => DietPageState();
}

class DietPageState extends State<DietPage> {
  final List<Map<String, dynamic>> _diets = [];
  final TextEditingController _dietController = TextEditingController();

  void _addDiet() {
    if (_dietController.text.isNotEmpty) {
      setState(() {
        _diets.add({
          'diet': _dietController.text,
          'icon': _getIconForDiet(_dietController.text), // Dynamically assign icon
        });
        _dietController.clear();
      });
    }
  }

  IconData _getIconForDiet(String diet) {
    // Add your logic here to determine the icon based on diet
    // For example, different icons for fruits, vegetables, fast food, etc.
    return Icons.fastfood; // Placeholder icon
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diet Tracker'),
      backgroundColor: Theme.of(context).colorScheme.secondary,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _dietController,
              decoration: const InputDecoration(
                labelText: 'Enter what you ate',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addDiet(), // Add item on keyboard submission
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: _diets.length,
              itemBuilder: (context, index) {
                final diet = _diets[index];
                return ListTile(
                  leading: Icon(diet['icon']), // Display the assigned icon
                  title: Text(diet['diet']),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDiet,
        tooltip: 'Add Diet Item', // Tooltip for better UX
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
