import 'package:flutter/material.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// Role-specific theme definitions
class RoleThemes {
  // Private constructor to prevent instantiation
  RoleThemes._();

  /// Employee role colors (Blue theme)
  static const Color employeePrimary = Color(0xFF2563EB);
  static const Color employeePrimaryLight = Color(0xFF5A7FFF);
  static const Color employeePrimaryDark = Color(0xFF1E40AF);
  static const Color employeeAccent = Color(0xFF38BDF8);
  static const Color employeeBackground = Color(0xFFF0F9FF);
  static const Color employeeSurface = Color(0xFFE0F2FE);
  static const Color employeeError = Color(0xFFEF4444);

  /// Employer role colors (Green theme)
  static const Color employerPrimary = Color(0xFF059669);
  static const Color employerPrimaryLight = Color(0xFF10B981);
  static const Color employerPrimaryDark = Color(0xFF047857);
  static const Color employerAccent = Color(0xFF34D399);
  static const Color employerBackground = Color(0xFFECFDF5);
  static const Color employerSurface = Color(0xFFD1FAE5);
  static const Color employerError = Color(0xFFEF4444);

  /// Admin role colors (Indigo theme)
  static const Color adminPrimary = Color(0xFF4F46E5);
  static const Color adminPrimaryLight = Color(0xFF6366F1);
  static const Color adminPrimaryDark = Color(0xFF4338CA);
  static const Color adminAccent = Color(0xFFA5B4FC);
  static const Color adminBackground = Color(0xFFEEF2FF);
  static const Color adminSurface = Color(0xFFE0E7FF);
  static const Color adminError = Color(0xFFEF4444);

  /// Get light theme for employee role
  static ThemeData employeeLightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: employeePrimary,
    scaffoldBackgroundColor: employeeBackground,
    colorScheme: const ColorScheme.light(
      primary: employeePrimary,
      secondary: employeeAccent,
      error: employeeError,
      surface: employeeSurface,
      // Using surfaceVariant instead of deprecated background
      surfaceContainerHighest: employeeBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: employeePrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: employeePrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: employeePrimary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  /// Get dark theme for employee role
  static ThemeData employeeDarkTheme = AppTheme.darkTheme.copyWith(
    primaryColor: employeePrimary,
    colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
      primary: employeePrimary,
      secondary: employeeAccent,
    ),
    appBarTheme: AppTheme.darkTheme.appBarTheme.copyWith(
      backgroundColor: AppTheme.darkSurface2,
      iconTheme: const IconThemeData(
        color: employeePrimary,
      ),
    ),
    bottomNavigationBarTheme:
        AppTheme.darkTheme.bottomNavigationBarTheme.copyWith(
      selectedItemColor: employeePrimary,
    ),
  );

  /// Get light theme for employer role
  static ThemeData employerLightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: employerPrimary,
    scaffoldBackgroundColor: employerBackground,
    colorScheme: const ColorScheme.light(
      primary: employerPrimary,
      secondary: employerAccent,
      error: employerError,
      surface: employerSurface,
      // Using surfaceVariant instead of deprecated background
      surfaceContainerHighest: employerBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: employerPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: employerPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: employerPrimary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  /// Get dark theme for employer role
  static ThemeData employerDarkTheme = AppTheme.darkTheme.copyWith(
    primaryColor: employerPrimary,
    colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
      primary: employerPrimary,
      secondary: employerAccent,
    ),
    appBarTheme: AppTheme.darkTheme.appBarTheme.copyWith(
      backgroundColor: AppTheme.darkSurface2,
      iconTheme: const IconThemeData(
        color: employerPrimary,
      ),
    ),
    bottomNavigationBarTheme:
        AppTheme.darkTheme.bottomNavigationBarTheme.copyWith(
      selectedItemColor: employerPrimary,
    ),
  );

  /// Get light theme for admin role
  static ThemeData adminLightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: adminPrimary,
    scaffoldBackgroundColor: adminBackground,
    colorScheme: const ColorScheme.light(
      primary: adminPrimary,
      secondary: adminAccent,
      error: adminError,
      surface: adminSurface,
      // Using surfaceVariant instead of deprecated background
      surfaceContainerHighest: adminBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: adminPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: adminPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: adminPrimary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  /// Get dark theme for admin role
  static ThemeData adminDarkTheme = AppTheme.darkTheme.copyWith(
    primaryColor: adminPrimary,
    colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
      primary: adminPrimary,
      secondary: adminAccent,
    ),
    appBarTheme: AppTheme.darkTheme.appBarTheme.copyWith(
      backgroundColor: AppTheme.darkSurface2,
      iconTheme: const IconThemeData(
        color: adminPrimary,
      ),
    ),
    bottomNavigationBarTheme:
        AppTheme.darkTheme.bottomNavigationBarTheme.copyWith(
      selectedItemColor: adminPrimary,
    ),
  );

  /// Get theme data based on user role and dark mode preference
  static ThemeData getThemeForRole(UserType? role, bool isDarkMode) {
    // ignore: no_default_cases
    switch (role) {
      case UserType.employee:
        return isDarkMode ? employeeDarkTheme : employeeLightTheme;
      case UserType.employer:
        return isDarkMode ? employerDarkTheme : employerLightTheme;
      case UserType.admin:
        return isDarkMode ? adminDarkTheme : adminLightTheme;
      case null:
        return isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    }
  }
}
