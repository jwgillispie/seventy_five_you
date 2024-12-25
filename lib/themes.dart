import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorPalette {
  final String name;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color neutral;
  final Color background;

  const ColorPalette({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.neutral,
    required this.background,
  });
}

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'selected_theme';
  static const List<ColorPalette> funkyPalettes = [
    ColorPalette(
      name: 'Ocean Dreams',
      primary: Color(0xFF084B83),     // Deep Ocean Blue
      secondary: Color(0xFF42BFDD),   // Bright Azure
      tertiary: Color(0xFFBBE6E4),    // Soft Aqua
      neutral: Color(0xFFF0F6F6),     // Ice White
      background: Color(0xFFFF66B3),  // Coral Pink
    ),
    ColorPalette(
      name: 'Mystic Twilight',
      primary: Color(0xFF59C3C3),     // Vibrant Teal
      secondary: Color(0xFF52489C),   // Deep Purple
      tertiary: Color(0xFFEBEBEB),    // Soft Gray
      neutral: Color(0xFFCAD2C5),     // Sage
      background: Color(0xFF84A98C),  // Forest Green
    ),
    ColorPalette(
      name: 'Coastal Vibes',
      primary: Color(0xFF00BFB2),     // Turquoise
      secondary: Color(0xFF1A5E63),   // Deep Sea
      tertiary: Color(0xFF028090),    // Ocean Blue
      neutral: Color(0xFFF0F3BD),     // Sand Yellow
      background: Color(0xFFC64191),  // Magenta
    ),
    ColorPalette(
      name: 'Desert Sunset',
      primary: Color(0xFFC54545),     // Terra Red
      secondary: Color(0xFFFF715B),   // Coral Orange
      tertiary: Color(0xFFFFFFFF),    // Pure White
      neutral: Color(0xFF1EA896),     // Turquoise
      background: Color(0xFF523F38),  // Deep Brown
    ),
    ColorPalette(
      name: 'Midnight Edge',
      primary: Color(0xFF1E1E24),     // Night Black
      secondary: Color(0xFF92140C),   // Blood Red
      tertiary: Color(0xFFFFF8F0),    // Cream White
      neutral: Color(0xFFFFCF99),     // Peach
      background: Color(0xFF111D4A),  // Navy Blue
    ),
    ColorPalette(
      name: 'Aurora Borealis',
      primary: Color(0xFF673C4F),     // Deep Purple
      secondary: Color(0xFF7F557D),   // Mauve
      tertiary: Color(0xFF726E97),    // Lavender
      neutral: Color(0xFF7698B3),     // Steel Blue
      background: Color(0xFF83B5D1),  // Sky Blue
    ),
  ];

  int _selectedPaletteIndex = 0;

  ColorPalette get currentPalette => funkyPalettes[_selectedPaletteIndex];

  ThemeProvider() {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedPaletteIndex = prefs.getInt(_themeKey) ?? 0;
    notifyListeners();
  }

  Future<void> setTheme(int index) async {
    if (index < 0 || index >= funkyPalettes.length) return;

    _selectedPaletteIndex = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, index);
    notifyListeners();
  }

  ThemeData getTheme(Brightness brightness) {
    final palette = currentPalette;

    return ThemeData(
      brightness: brightness,
      primaryColor: palette.primary,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? palette.neutral // Using neutral as the main background for better contrast
          : Color(0xFF121212),
      
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: palette.primary,
        secondary: palette.secondary,
        tertiary: palette.tertiary,
        secondaryFixed: palette.neutral,
        background: palette.neutral,
        surface: Colors.white,
        error: palette.primary,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onBackground: Colors.black87,
        onSurface: Colors.black87,
        onError: Colors.white,
      ),
    );
  }
}