
// lib/features/tracking/presentation/diet/pages/diet_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';
import 'package:seventy_five_hard/features/tracking/data/models/diet_tracking_model.dart';
import '../bloc/diet_bloc.dart';
import '../widgets/meal_card.dart';
import '../widgets/nutrition_summary.dart';

class DietPage extends StatefulWidget {
  const DietPage({Key? key}) : super(key: key);

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> with SingleTickerProviderStateMixin {
  late DietBloc _dietBloc;
  late AnimationController _animationController;
  final TextEditingController _mealController = TextEditingController();
  DateTime today = DateTime.now();
  bool _isSubmitting = false;

  final Map<String, Map<String, dynamic>> mealCategories = {
    'Breakfast': {
      'icon': Icons.wb_sunny,
      'gradient': [SFColors.primary, SFColors.secondary],
    },
    'Lunch': {
      'icon': Icons.restaurant,
      'gradient': [SFColors.tertiary, SFColors.secondary],
    },
    'Dinner': {
      'icon': Icons.nightlight_round,
      'gradient': [SFColors.neutral, SFColors.tertiary],
    },
    'Snacks': {
      'icon': Icons.cookie,
      'gradient': [SFColors.secondary, SFColors.background],
    }
  };

  @override
  void initState() {
    super.initState();
    _dietBloc = DietBloc();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
    _fetchDietData();
  }

  void _fetchDietData() {
    _dietBloc.add(FetchDietData(today.toString().substring(0, 10)));
  }

  void _showAddMealDialog(String mealType, DietTrackingModel diet) {
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
              color: SFColors.surface,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add to $mealType',
                  style: GoogleFonts.orbitron(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: SFColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _mealController,
                  decoration: InputDecoration(
                    hintText: 'What did you eat?',
                    filled: true,
                    fillColor: SFColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
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
                        style: TextStyle(color: SFColors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        if (_mealController.text.isNotEmpty) {
                          setState(() => _isSubmitting = true);
                          List<String> updatedMeals = [];
                          switch (mealType) {
                            case 'Breakfast':
                              updatedMeals = [...(diet.breakfast ?? []), _mealController.text];
                              diet.breakfast = updatedMeals;
                              break;
                            case 'Lunch':
                              updatedMeals = [...(diet.lunch ?? []), _mealController.text];
                              diet.lunch = updatedMeals;
                              break;
                            case 'Dinner':
                              updatedMeals = [...(diet.dinner ?? []), _mealController.text];
                              diet.dinner = updatedMeals;
                              break;
                            case 'Snacks':
                              updatedMeals = [...(diet.snacks ?? []), _mealController.text];
                              diet.snacks = updatedMeals;
                              break;
                          }
                          _dietBloc.add(SubmitMeal(
                            diet: diet,
                            date: today.toString().substring(0, 10),
                          ));
                          Navigator.pop(context);
                          _mealController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SFColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Add Meal'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [SFColors.surface, SFColors.background],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<DietBloc, DietState>(
            bloc: _dietBloc,
            builder: (context, state) {
              if (state is DietLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DietLoaded) {
                return Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const NutritionSummary(),
                            const SizedBox(height: 24),
                            ...mealCategories.entries.map((entry) {
                              List<String> meals = [];
                              switch (entry.key) {
                                case 'Breakfast':
                                  meals = state.diet.breakfast ?? [];
                                  break;
                                case 'Lunch':
                                  meals = state.diet.lunch ?? [];
                                  break;
                                case 'Dinner':
                                  meals = state.diet.dinner ?? [];
                                  break;
                                case 'Snacks':
                                  meals = state.diet.snacks ?? [];
                                  break;
                              }
                              return MealCard(
                                mealType: entry.key,
                                meals: meals,
                                gradientColors: entry.value['gradient'],
                                icon: entry.value['icon'],
                                onAddPressed: () => _showAddMealDialog(entry.key, state.diet),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is DietError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [SFColors.neutral, SFColors.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: SFColors.neutral.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diet Tracker',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: SFColors.surface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track your nutrition journey',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: SFColors.surface.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              _buildProgressRing(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRing() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            SFColors.surface.withOpacity(0.2),
            SFColors.surface.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Text(
          '80%',
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: SFColors.surface,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dietBloc.close();
    _animationController.dispose();
    _mealController.dispose();
    super.dispose();
  }
}