import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seventy_five_hard/core/themes/app_colors.dart';
import 'package:seventy_five_hard/core/themes/app_decorations.dart';

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
        error: Color(0xFFB23B3B),
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
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.dark(
        primary: SFColors.primary,
        secondary: SFColors.secondary,
        tertiary: SFColors.tertiary,
        surface: const Color(0xFF2A2A2A),
        background: const Color(0xFF1A1A1A),
        error: const Color(0xFFB23B3B),
        onPrimary: Colors.white,
        onSecondary: SFColors.textPrimary,
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
      headlineMedium: _safeGoogleFont('Inter', TextStyle(
        fontSize: 20,
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
    );
  }
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
}