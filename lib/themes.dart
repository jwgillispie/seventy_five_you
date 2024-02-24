import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:google_fonts/google_fonts.dart';
// import 'package:habo/constants.dart';
class SystemsColors {
  static const Color primary = Color.fromARGB(255, 191, 118, 9);
  // static const Color red = Color(0xFFF44336);
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
          offset: Offset(0, 3),
        ),
      ],
    );
  }

  static BoxDecoration get darkContainerShadow {
    return BoxDecoration(
      color: Color(0xFF505050),
      borderRadius: BorderRadius.circular(10), // Or any dark color you prefer
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.grey.withOpacity(0.2), // Subtle shadow color
      //     spreadRadius: 0,
      //     blurRadius: 10, // Soft blur
      //     offset: Offset(0, 4), // Slight vertical offset
      //   ),
      // ],
    );
  }
}

class SFThemes {
  static TextTheme _customTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: SystemsColors.primary),
      displayMedium: base.displayMedium
          ?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 16),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 14),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor:
          const Color(0xFFFFF9C4), // Light, sunny background
      brightness: Brightness.light,
      primaryColor:
          const Color(0xFFFFEB3B), // Bright yellow for primary elements
      colorScheme: const ColorScheme.light(
        primary: const Color(0xFFFFEB3B), // Bright yellow for primary elements
        secondary: const Color(0xFF81C784), // Fresh green for a lively accent
        surface: Colors.white,
        background: const Color(0xFFFFF9C4),
        onPrimary: Colors.black, // Black text on primary color for readability
        onSecondary: Colors.white, // White text on secondary color
      ),
      appBarTheme: const AppBarTheme(
        color: const Color(0xFFFFEB3B),
        elevation: 0,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.black87),
        displayMedium: TextStyle(color: Colors.black87),
        displaySmall: TextStyle(color: Colors.black87,
        ),  
      ),
      // Other theme customizations
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor:
          const Color(0xFF1A1A1A), // Very dark shade for background
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0A0A0A), // Dark grey for primary elements
      colorScheme: const ColorScheme.dark(
        primary: const Color(
            0xFF4A90E2), // Cool blue for primary elements, adds a sleek touch
        secondary: const Color(0xFF4A148C), // Accent color for a modern look
        surface: const Color(0xFF1A1A1A),
        background: const Color(0xFF121212),
        onPrimary: Colors.white, // White text on primary color for contrast
        onSecondary: Colors.black, // Black text on secondary color
      ),
      appBarTheme: const AppBarTheme(
        color: const Color(0xFF0A0A0A),
        elevation: 0,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.grey[300]),
        displayMedium: TextStyle(color: Colors.grey[300]),
      ),
      // Other theme customizations
    );
  }
}
