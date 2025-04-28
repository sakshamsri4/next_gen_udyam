import 'package:flutter/material.dart';

/// App theme configuration implementing NeoPOP design system
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Primary color palette based on NeoPOP design system
  static const Color navyBlue = Color(0xFF0A1126);
  static const Color electricBlue = Color(0xFF3D63FF);
  static const Color mintGreen = Color(0xFF00A651);
  static const Color coralRed = Color(0xFFE63946);
  static const Color pureWhite = Color(0xFFFFFFFF);

  /// Secondary color palette
  static const Color slateGray = Color(0xFF6C757D);
  static const Color lavender = Color(0xFF7F5AF0);
  static const Color teal = Color(0xFF2EC4B6);
  static const Color amber = Color(0xFFFF9F1C);
  static const Color lightGray = Color(0xFFF8F9FA);

  /// Light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: electricBlue,
    scaffoldBackgroundColor: lightGray,
    colorScheme: const ColorScheme.light(
      primary: electricBlue,
      secondary: lavender,
      error: coralRed,
      background: lightGray,
      surface: pureWhite,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: electricBlue,
      foregroundColor: pureWhite,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: electricBlue,
        foregroundColor: pureWhite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: electricBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    cardTheme: CardTheme(
      color: pureWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: pureWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: slateGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: slateGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: electricBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: coralRed, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: navyBlue,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: navyBlue,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: navyBlue,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: navyBlue,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: navyBlue,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: navyBlue,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: navyBlue,
      ),
    ),
  );

  /// Dark theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: electricBlue,
    scaffoldBackgroundColor: navyBlue,
    colorScheme: const ColorScheme.dark(
      primary: electricBlue,
      secondary: lavender,
      error: coralRed,
      background: navyBlue,
      surface: Color(0xFF1A2138), // Slightly lighter than navyBlue
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A2138),
      foregroundColor: pureWhite,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: electricBlue,
        foregroundColor: pureWhite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: electricBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1A2138),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A2138),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: slateGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: slateGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: electricBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: coralRed, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: pureWhite,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: pureWhite,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: pureWhite,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: pureWhite,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: pureWhite,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: pureWhite,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: pureWhite,
      ),
    ),
  );
}
