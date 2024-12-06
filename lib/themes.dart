import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SFColors {
  static const Color primary = Color(0xFF047E55);
  static const Color secondary = Color(0xFF48BF84);
  static const Color tertiary = Color(0xFF5A7D9A);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFBF9648);
  static const Color error = Color(0xFFB23B3B);
  static const Color info = Color(0xFF0288D1);
  static const Color background = Color(0xFFF5F7F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF718096);
  
  static const List<Color> primaryGradient = [
    Color(0xFF047E55),
    Color(0xFF48BF84),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFF5A7D9A),
    Color(0xFF89A7C4),
  ];
}

class SFDecorations {
  static BoxDecoration get whiteContainerShadow => BoxDecoration(
    color: SFColors.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.15),
        spreadRadius: 2,
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  static BoxDecoration get gradientContainer => BoxDecoration(
    gradient: const LinearGradient(
      colors: SFColors.primaryGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: SFColors.primary.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: SFColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: SFColors.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

class SFThemes {
  static TextStyle _safeGoogleFont(String fontFamily, TextStyle baseStyle) {
    try {
      return GoogleFonts.getFont(fontFamily).copyWith(
        fontSize: baseStyle.fontSize,
        fontWeight: baseStyle.fontWeight,
        color: baseStyle.color,
        letterSpacing: baseStyle.letterSpacing,
      );
    } catch (e) {
      return baseStyle;
    }
  }

  static ThemeData get lightTheme {
    final baseTextTheme = _buildTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: SFColors.background,
      brightness: Brightness.light,
      primaryColor: SFColors.primary,
      
      colorScheme: const ColorScheme.light(
        primary: SFColors.primary,
        secondary: SFColors.secondary,
        tertiary: SFColors.tertiary,
        surface: SFColors.surface,
        background: SFColors.background,
        error: SFColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: SFColors.textPrimary,
        onBackground: SFColors.textPrimary,
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: SFColors.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _safeGoogleFont('Inter', 
          const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      textTheme: baseTextTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: SFDecorations.primaryButton,
      ),
      
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: SFColors.surface,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SFColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: SFColors.textSecondary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: SFColors.textSecondary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SFColors.primary),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF121212),
      brightness: Brightness.dark,
      
      colorScheme: const ColorScheme.dark(
        primary: SFColors.primary,
        secondary: SFColors.secondary,
        tertiary: SFColors.tertiary,
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF121212),
        error: SFColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
      
      textTheme: _buildTextTheme(isDark: true),
    );
  }

  static TextTheme _buildTextTheme({bool isDark = false}) {
    final Color textColor = isDark ? Colors.white : SFColors.textPrimary;
    final Color mutedColor = isDark ? Colors.white70 : SFColors.textSecondary;
    
    return TextTheme(
      displayLarge: _safeGoogleFont('Inter', TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: -0.5,
      )),
      displayMedium: _safeGoogleFont('Inter', TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: -0.5,
      )),
      displaySmall: _safeGoogleFont('Inter', TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      )),
      headlineLarge: _safeGoogleFont('Inter', TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
      )),
      headlineMedium: _safeGoogleFont('Inter', TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      )),
      headlineSmall: _safeGoogleFont('Inter', TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      )),
      bodyLarge: _safeGoogleFont('Inter', TextStyle(
        fontSize: 16,
        color: mutedColor,
      )),
      bodyMedium: _safeGoogleFont('Inter', TextStyle(
        fontSize: 14,
        color: mutedColor,
      )),
      bodySmall: _safeGoogleFont('Inter', TextStyle(
        fontSize: 12,
        color: mutedColor,
      )),
    );
  }
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
}