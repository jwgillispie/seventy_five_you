import 'package:flutter/material.dart';

class SFColors {
  static const Color primary = Color.fromARGB(255, 4, 114, 77);
  static const Color secondary = Color.fromARGB(255, 72, 191, 132);
  static const Color navyBlue = Color.fromARGB(255, 90,125,154);
  // static const Color skip = Color(0xFFFBC02D);
  // static const Color orange = Color(0xFFFF9800);
}

class SFDecorations {
  static BoxDecoration get whiteContainerShadow {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

class SFThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Soft white background
      brightness: Brightness.light,
      primaryColor: SFColors.primary,

      /// Subdued blue for primary elements
      // primaryColor: Color.fromARGB(255, 33, 3, 81),
      colorScheme: const ColorScheme.light(
        primary: SFColors.primary, // Consistent blue for primary elements
        secondary: SFColors.secondary, // Complementary deep purple for accents
        surface: Colors.white,
        background: Color(0xFFF3F4F6),
        onPrimary: Colors.white, // White text on primary color for readability
        onSecondary: Colors.white, // White text on secondary color
      ),
      appBarTheme: const AppBarTheme(
        color: const Color.fromARGB(255, 7, 255, 214),
        elevation: 0,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textTheme: _customTextTheme(const TextTheme(
        displayLarge: TextStyle(color: Colors.black87, fontSize: 24),
        displayMedium: TextStyle(color: Colors.black87, fontSize: 20),
        displaySmall: TextStyle(color: Colors.black87, fontSize: 16),
      )),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF121212), // Deep dark background
      brightness: Brightness.dark,
      // primaryColor: const const Color.fromARGB(255, 7, 255, 214), // Consistent blue for primary elements
      primaryColor: SFColors.primary,

      colorScheme: const ColorScheme.dark(
        primary: SFColors.primary, // Cool blue for primary elements
        secondary: SFColors.secondary, // Deep purple for a modern look
        surface: Color(0xFF1A1A1A),
        background: Color(0xFF121212),
        onPrimary: Colors.white, // White text on primary color for contrast
        onSecondary: Colors.white, // White text on secondary color
      ),
      appBarTheme: const AppBarTheme(
        color: SFColors.primary,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textTheme: _customTextTheme(const TextTheme(
        displayLarge: TextStyle(color: Colors.white70, fontSize: 24),
        displayMedium: TextStyle(color: Colors.white70, fontSize: 20),
        displaySmall: TextStyle(color: Colors.white70, fontSize: 16),
      )),
    );
  }

  static TextTheme _customTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 7, 255, 214)),
      displayMedium: base.displayMedium?.copyWith(
          fontSize: 22, fontWeight: FontWeight.bold, color: SFColors.primary),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 16),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 14),
      bodySmall: base.bodySmall?.copyWith(fontSize: 12),
    );
  }
}
