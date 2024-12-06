import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seventy_five_hard/features/presentation/models/diet_model.dart';
import 'package:seventy_five_hard/features/presentation/models/day_model.dart';
import 'package:seventy_five_hard/themes.dart';

class DietPage extends StatefulWidget {
  const DietPage({Key? key}) : super(key: key);

  @override
  DietPageState createState() => DietPageState();
}

class DietPageState extends State<DietPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final cardAnimations = <String, Animation<double>>{};
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Day? day;
  Diet? diet;
  DateTime today = DateTime.now();

  // Enhanced meal categories with additional styling information
  final Map<String, Map<String, dynamic>> mealCategories = {
    'Breakfast': {
      'icon': Icons.wb_sunny,
      'gradient': const [Color(0xFFFF8C00), Color(0xFFFFD700)],
      'meals': <String>[],
    },
    'Lunch': {
      'icon': Icons.restaurant,
      'gradient': const [Color(0xFF4169E1), Color(0xFF00CED1)],
      'meals': <String>[],
    },
    'Dinner': {
      'icon': Icons.nightlight_round,
      'gradient': const [Color(0xFF8A2BE2), Color(0xFFFF69B4)],
      'meals': <String>[],
    },
    'Snacks': {
      'icon': Icons.cookie,
      'gradient': const [Color(0xFF32CD32), Color(0xFF98FB98)],
      'meals': <String>[],
    }
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Create staggered animations for each meal card
    mealCategories.keys.toList().asMap().forEach((index, meal) {
      cardAnimations[meal] = CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1, // Stagger start times
          1.0,
          curve: Curves.easeInOut,
        ),
      );
    });
    
    _animationController.forward();
    super.initState();
    user = _auth.currentUser;
    _fetchDayData();
  }





  Future<void> _fetchDayData() async {
    if (user == null) return;

    String formattedDate = today.toString().substring(0, 10);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/day/${user!.uid}/$formattedDate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (!mounted) return; // Add check before setState

      if (response.statusCode == 200) {
        setState(() {
          day = Day.fromJson(json.decode(response.body));
          diet = day!.diet;
          if (diet != null) {
            mealCategories['Breakfast']?['meals'] = diet!.breakfast ?? [];
            mealCategories['Lunch']?['meals'] = diet!.lunch ?? [];
            mealCategories['Dinner']?['meals'] = diet!.dinner ?? [];
            mealCategories['Snacks']?['meals'] = diet!.snacks ?? [];
          }
        });
      } else {
        _showErrorSnackBar("Failed to fetch data");
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar("Error: $e");
    }
  }

  Future<void> submitMeal(String mealType, String newMeal) async {
    if (user == null || diet == null) return;

    switch (mealType) {
      case 'Breakfast':
        diet!.breakfast = (diet!.breakfast ?? [])..add(newMeal);
        break;
      case 'Lunch':
        diet!.lunch = (diet!.lunch ?? [])..add(newMeal);
        break;
      case 'Dinner':
        diet!.dinner = (diet!.dinner ?? [])..add(newMeal);
        break;
      case 'Snacks':
        diet!.snacks = (diet!.snacks ?? [])..add(newMeal);
        break;
    }

    final Map<String, dynamic> dietData = diet!.toJson();

    try {
      final response = await http.put(
        Uri.parse(
            'http://localhost:8000/day/${user!.uid}/${today.toString().substring(0, 10)}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'diet': dietData}),
      );

      if (response.statusCode == 200) {
        _showSuccessSnackBar('Meal added successfully!');
      } else {
        _showErrorSnackBar('Failed to update diet data');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  void _showAddMealDialog(String mealType) {
    final TextEditingController mealController = TextEditingController();
    final theme = Theme.of(context);
    final category = mealCategories[mealType]!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: theme.cardColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: category['gradient'],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        category['icon'],
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Add $mealType',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: mealController,
                  decoration: InputDecoration(
                    hintText: 'What did you eat?',
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.restaurant_menu),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (mealController.text.isNotEmpty) {
                          setState(() {
                            mealCategories[mealType]?['meals']
                                .add(mealController.text);
                          });
                          submitMeal(mealType, mealController.text);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add Meal'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diet Tracker',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track your nutrition journey',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildProgressRing(theme),
            ],
          ),
          const SizedBox(height: 20),
          _buildNutritionSummary(theme),
        ],
      ),
    );
  }
    Widget _buildProgressRing(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.secondary,
            theme.colorScheme.primary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '80%',
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionSummary(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNutrientItem('Protein', '75g', Icons.fitness_center, theme),
        _buildNutrientItem('Carbs', '200g', Icons.grain, theme),
        _buildNutrientItem('Fats', '55g', Icons.opacity, theme),
      ],
    );
  }

  Widget _buildNutrientItem(String label, String value, IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildMealCard(String mealType, ThemeData theme) {
    final category = mealCategories[mealType]!;
    final meals = category['meals'] as List<String>;

    return ScaleTransition(
      scale: cardAnimations[mealType]!,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.cardColor,
                theme.cardColor.withOpacity(0.95),
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: category['gradient'],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      category['icon'],
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    mealType,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                    onPressed: () => _showAddMealDialog(mealType),
                  ),
                ),
              ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.restaurant_menu),
                  title: Text(
                    meals[index],
                    style: GoogleFonts.inter(),
                  ),
                  subtitle: Text(
                    DateTime.now()
                        .subtract(Duration(minutes: index * 30))
                        .toString()
                        .substring(11, 16),
                    style: TextStyle(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor.withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(theme),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 20),
                  children: mealCategories.keys
                      .map((mealType) => _buildMealCard(mealType, theme))
                      .toList(),
                ),
              ),
              _buildStatsBar(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBar(ThemeData theme) {
    return Container(
      height: 60, // Fixed height
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('1,850', 'Calories', Icons.local_fire_department,
              Colors.orange, theme),
          _buildStatItem(
              '75g', 'Protein', Icons.fitness_center, Colors.blue, theme),
          _buildStatItem(
              '4/5', 'Meals', Icons.restaurant_menu, Colors.green, theme),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String value, String label, IconData icon, Color color, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            Text(label,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12)),
          ],
        ),
      ],
    );
  }
  // Update SnackBar methods to position above stats bar
void _showErrorSnackBar(String message) {
  if (!mounted) return;
  
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red.shade800,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 80), // Position above stats bar
    ),
  );
}

void _showSuccessSnackBar(String message) {
  if (!mounted) return;
  
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green.shade800,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 80), // Position above stats bar
    ),
  );
}
}
