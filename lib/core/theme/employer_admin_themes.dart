import 'package:flutter/material.dart';
import 'package:next_gen/core/theme/role_themes_updated.dart';

/// Employer light theme
final ThemeData employerLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: RoleThemes.employerPrimary,
  scaffoldBackgroundColor: RoleThemes.employerBackground,
  colorScheme: RoleThemes.employerLightColorScheme,
  appBarTheme: const AppBarTheme(
    backgroundColor: RoleThemes.employerPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: RoleThemes.employerPrimary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: RoleThemes.employerPrimary,
      side: const BorderSide(color: RoleThemes.employerPrimary, width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: RoleThemes.employerPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    clipBehavior: Clip.antiAlias,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: RoleThemes.employerPrimary,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF1E293B),
    contentTextStyle: TextStyle(color: Colors.white),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: RoleThemes.employerBackground,
    selectedColor: RoleThemes.employerPrimary,
    secondarySelectedColor: RoleThemes.employerPrimaryLight,
    labelStyle: const TextStyle(color: Color(0xFF1E293B)),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFFE2E8F0),
    thickness: 1,
    space: 24,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return RoleThemes.employerPrimary;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    side: const BorderSide(color: Color(0xFF94A3B8), width: 1.5),
  ),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return RoleThemes.employerPrimary;
      }
      return const Color(0xFF94A3B8);
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return RoleThemes.employerPrimary;
      }
      return Colors.white;
    }),
    trackColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return RoleThemes.employerPrimaryLight.withAlpha(128); // 50% opacity
      }
      return const Color(0xFFCBD5E1);
    }),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: RoleThemes.employerPrimary,
    circularTrackColor: Color(0xFFE2E8F0),
    linearTrackColor: Color(0xFFE2E8F0),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: RoleThemes.employerPrimary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: RoleThemes.employerError),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: RoleThemes.employerError, width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFF64748B)),
    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
    errorStyle: const TextStyle(color: RoleThemes.employerError),
  ),
);

/// Employer dark theme
final ThemeData employerDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: RoleThemes.employerPrimary,
  scaffoldBackgroundColor: const Color(0xFF0F172A),
  colorScheme: RoleThemes.employerDarkColorScheme,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E293B),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: RoleThemes.employerPrimaryLight,
    ),
  ),
  // Other theme properties similar to employeeDarkTheme but with employer colors
);

/// Admin light theme
final ThemeData adminLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: RoleThemes.adminPrimary,
  scaffoldBackgroundColor: RoleThemes.adminBackground,
  colorScheme: RoleThemes.adminLightColorScheme,
  appBarTheme: const AppBarTheme(
    backgroundColor: RoleThemes.adminPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  // Other theme properties similar to employeeLightTheme but with admin colors
);

/// Admin dark theme
final ThemeData adminDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: RoleThemes.adminPrimary,
  scaffoldBackgroundColor: const Color(0xFF0F172A),
  colorScheme: RoleThemes.adminDarkColorScheme,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E293B),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: RoleThemes.adminPrimaryLight,
    ),
  ),
  // Other theme properties similar to employeeDarkTheme but with admin colors
);
