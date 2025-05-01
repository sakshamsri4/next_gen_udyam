import 'package:flutter/material.dart';

/// App theme configuration implementing NeoPOP design system
class AppTheme {
  // Private constructor to prevent instantiation
  // ignore: unused_element
  AppTheme._();

  /// Primary color palette based on NeoPOP design system
  static const Color navyBlue = Color(0xFF0A1126);
  static const Color deepNavy =
      Color(0xFF050A17); // Darker navy for backgrounds
  static const Color electricBlue = Color(0xFF3D63FF);
  static const Color brightElectricBlue =
      Color(0xFF5A7FFF); // Brighter blue for accents
  static const Color mintGreen = Color(0xFF00A651);
  static const Color neonGreen = Color(0xFF00E676); // Neon green for accents
  static const Color coralRed = Color(0xFFE63946);
  static const Color neonPink = Color(0xFFFF2D55); // Neon pink for accents
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color offWhite =
      Color(0xFFF0F0F0); // Slightly off-white for text

  /// Secondary color palette
  static const Color slateGray = Color(0xFF6C757D);
  static const Color darkSlateGray =
      Color(0xFF343A40); // Darker slate for surfaces
  static const Color lavender = Color(0xFF7F5AF0);
  static const Color brightLavender =
      Color(0xFF9D7FFF); // Brighter lavender for accents
  static const Color teal = Color(0xFF2EC4B6);
  static const Color neonTeal = Color(0xFF00F5D4); // Neon teal for accents
  static const Color amber = Color(0xFFFF9F1C);
  static const Color neonYellow = Color(0xFFFFD60A); // Neon yellow for accents
  static const Color lightGray = Color(0xFFF8F9FA);

  /// Surface colors for dark theme
  static const Color darkSurface1 = Color(0xFF121827); // Primary surface
  static const Color darkSurface2 = Color(0xFF1A2138); // Secondary surface
  static const Color darkSurface3 = Color(0xFF232A40); // Tertiary surface

  /// Light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: electricBlue,
    scaffoldBackgroundColor: lightGray,
    colorScheme: const ColorScheme.light(
      primary: electricBlue,
      secondary: lavender,
      error: coralRed,
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

  /// Dark theme with enhanced NeoPOP styling
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: brightElectricBlue,
    scaffoldBackgroundColor: deepNavy,
    colorScheme: const ColorScheme.dark(
      primary: brightElectricBlue,
      secondary: brightLavender,
      tertiary: neonTeal,
      error: neonPink,
      surface: darkSurface1,
      onPrimary: pureWhite,
      onSecondary: pureWhite,
      onSurface: offWhite,
      onError: pureWhite,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface2,
      foregroundColor: pureWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(
        color: brightElectricBlue,
        size: 24,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brightElectricBlue,
        foregroundColor: pureWhite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 8,
        shadowColor: electricBlue.withAlpha(128),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: brightElectricBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: darkSurface2,
      elevation: 8,
      shadowColor: Colors.black.withAlpha(128),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: darkSurface3),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: darkSurface3,
      thickness: 1,
      space: 32,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface2,
      hoverColor: darkSurface3,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkSlateGray, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkSlateGray, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: brightElectricBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: neonPink, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      labelStyle: const TextStyle(
        color: slateGray,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      hintStyle: TextStyle(
        color: slateGray.withAlpha(179),
        fontWeight: FontWeight.normal,
      ),
      prefixIconColor: slateGray,
      suffixIconColor: slateGray,
      floatingLabelStyle: const TextStyle(
        color: brightElectricBlue,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: const IconThemeData(
      color: brightElectricBlue,
      size: 24,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: pureWhite,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: pureWhite,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: pureWhite,
        letterSpacing: -0.25,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: pureWhite,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: pureWhite,
        letterSpacing: 0.15,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: offWhite,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: offWhite,
        letterSpacing: 0.25,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: brightElectricBlue,
        letterSpacing: 0.5,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: darkSurface3,
      contentTextStyle: const TextStyle(color: offWhite),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: darkSurface2,
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: const TextStyle(
        color: pureWhite,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        color: offWhite,
        fontSize: 16,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface1,
      selectedItemColor: brightElectricBlue,
      unselectedItemColor: slateGray,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 12,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return brightElectricBlue;
        }
        return darkSurface3;
      }),
      checkColor: WidgetStateProperty.all(pureWhite),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: const BorderSide(color: slateGray, width: 1.5),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return brightElectricBlue;
        }
        return slateGray;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return brightElectricBlue;
        }
        return slateGray;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return brightElectricBlue.withAlpha(128);
        }
        return darkSurface3;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: brightElectricBlue,
      circularTrackColor: darkSurface3,
      linearTrackColor: darkSurface3,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: darkSurface3,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: offWhite),
    ),
    useMaterial3: true,
  );
}
