import 'package:flutter/material.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// Role-specific theme definitions with all errors fixed
class RoleThemes {
  // Private constructor to prevent instantiation
  RoleThemes._();

  /// Theme transition duration
  static const Duration themeChangeDuration = Duration(milliseconds: 300);

  /// Theme transition curve
  static const Curve themeChangeCurve = Curves.easeInOut;

  /// Shared semantic colors for all roles
  static const Color successColor = Color(0xFF10B981); // Green
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color infoColor = Color(0xFF3B82F6); // Blue
  static const Color errorColor = Color(0xFFDC2626); // Red

  /// Employee role colors (Blue theme) - #2563EB
  static const Color employeePrimary = Color(0xFF2563EB);
  static const Color employeePrimaryLight = Color(0xFF60A5FA);
  static const Color employeePrimaryDark = Color(0xFF1E40AF);
  static const Color employeeAccent = Color(0xFF38BDF8);
  static const Color employeeBackground = Color(0xFFF0F9FF);
  static const Color employeeSurface = Color(0xFFE0F2FE);
  static const Color employeeError = errorColor;
  static const Color employeeSuccess = successColor;
  static const Color employeeWarning = warningColor;
  static const Color employeeInfo = infoColor;

  /// Employer role colors (Green theme) - #059669
  static const Color employerPrimary = Color(0xFF059669);
  static const Color employerPrimaryLight = Color(0xFF10B981);
  static const Color employerPrimaryDark = Color(0xFF047857);
  static const Color employerAccent = Color(0xFF34D399);
  static const Color employerBackground = Color(0xFFECFDF5);
  static const Color employerSurface = Color(0xFFD1FAE5);
  static const Color employerError = errorColor;
  static const Color employerSuccess = successColor;
  static const Color employerWarning = warningColor;
  static const Color employerInfo = infoColor;

  /// Admin role colors (Indigo theme) - #4F46E5
  static const Color adminPrimary = Color(0xFF4F46E5);
  static const Color adminPrimaryLight = Color(0xFF6366F1);
  static const Color adminPrimaryDark = Color(0xFF4338CA);
  static const Color adminAccent = Color(0xFFA5B4FC);
  static const Color adminBackground = Color(0xFFEEF2FF);
  static const Color adminSurface = Color(0xFFE0E7FF);
  static const Color adminError = errorColor;
  static const Color adminSuccess = successColor;
  static const Color adminWarning = warningColor;
  static const Color adminInfo = infoColor;

  /// Get light theme for employee role
  static ThemeData employeeLightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: employeePrimary,
    scaffoldBackgroundColor: employeeBackground,
    colorScheme: const ColorScheme.light(
      primary: employeePrimary,
      primaryContainer: employeePrimaryDark,
      secondary: employeeAccent,
      secondaryContainer: Color(0xFFBAE6FD),
      surface: employeeSurface,
      error: employeeError,
      onSecondary: Color(0xFF0C4A6E),
      onSurface: Color(0xFF1E293B),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: employeePrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: employeePrimary,
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
        foregroundColor: employeePrimary,
        side: const BorderSide(color: employeePrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: employeePrimary,
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
      selectedItemColor: employeePrimary,
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
      backgroundColor: employeeBackground,
      selectedColor: employeePrimary,
      secondarySelectedColor: employeePrimaryLight,
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
          return employeePrimary;
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
          return employeePrimary;
        }
        return const Color(0xFF94A3B8);
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return employeePrimary;
        }
        return Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return employeePrimaryLight.withAlpha(128); // 50% opacity
        }
        return const Color(0xFFCBD5E1);
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: employeePrimary,
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
        borderSide: const BorderSide(color: employeePrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: employeeError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: employeeError, width: 2),
      ),
      labelStyle: const TextStyle(color: Color(0xFF64748B)),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      errorStyle: const TextStyle(color: employeeError),
    ),
  );

  /// Get dark theme for employee role
  static ThemeData employeeDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: employeePrimary,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    colorScheme: const ColorScheme.dark(
      primary: employeePrimary,
      primaryContainer: employeePrimaryLight,
      secondary: employeeAccent,
      secondaryContainer: Color(0xFF0284C7),
      surface: Color(0xFF1E293B),
      error: employeeError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFE2E8F0),
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E293B),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: employeePrimaryLight,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: employeePrimary,
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
        foregroundColor: employeePrimaryLight,
        side: const BorderSide(color: employeePrimaryLight, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: employeePrimaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E293B),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E293B),
      selectedItemColor: employeePrimaryLight,
      unselectedItemColor: Color(0xFF94A3B8),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF334155),
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF334155),
      selectedColor: employeePrimary,
      secondarySelectedColor: employeePrimaryLight,
      labelStyle: const TextStyle(color: Colors.white),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF334155),
      thickness: 1,
      space: 24,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return employeePrimary;
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
          return employeePrimary;
        }
        return const Color(0xFF94A3B8);
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return employeePrimaryLight;
        }
        return Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return employeePrimary.withAlpha(128); // 50% opacity
        }
        return const Color(0xFF475569);
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: employeePrimaryLight,
      circularTrackColor: Color(0xFF334155),
      linearTrackColor: Color(0xFF334155),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF475569)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF475569)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: employeePrimaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: employeeError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: employeeError, width: 2),
      ),
      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
      hintStyle: const TextStyle(color: Color(0xFF64748B)),
      errorStyle: const TextStyle(color: employeeError),
    ),
  );

  /// Get light theme for employer role
  static ThemeData employerLightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: employerPrimary,
    scaffoldBackgroundColor: employerBackground,
    colorScheme: const ColorScheme.light(
      primary: employerPrimary,
      primaryContainer: employerPrimaryDark,
      secondary: employerAccent,
      secondaryContainer: Color(0xFFA7F3D0),
      surface: employerSurface,
      error: employerError,
      onSecondary: Color(0xFF064E3B),
      onSurface: Color(0xFF1E293B),
    ),
    // Other theme properties similar to employeeLightTheme but with employer colors
  );

  /// Get dark theme for employer role
  static ThemeData employerDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: employerPrimary,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    colorScheme: const ColorScheme.dark(
      primary: employerPrimary,
      primaryContainer: employerPrimaryLight,
      secondary: employerAccent,
      secondaryContainer: Color(0xFF065F46),
      surface: Color(0xFF1E293B),
      error: employerError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFE2E8F0),
      onError: Colors.white,
    ),
    // Other theme properties similar to employeeDarkTheme but with employer colors
  );

  /// Get light theme for admin role
  static ThemeData adminLightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: adminPrimary,
    scaffoldBackgroundColor: adminBackground,
    colorScheme: const ColorScheme.light(
      primary: adminPrimary,
      primaryContainer: adminPrimaryDark,
      secondary: adminAccent,
      secondaryContainer: Color(0xFFC7D2FE),
      surface: adminSurface,
      error: adminError,
      onSecondary: Color(0xFF312E81),
      onSurface: Color(0xFF1E293B),
    ),
    // Other theme properties similar to employeeLightTheme but with admin colors
  );

  /// Get dark theme for admin role
  static ThemeData adminDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: adminPrimary,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    colorScheme: const ColorScheme.dark(
      primary: adminPrimary,
      primaryContainer: adminPrimaryLight,
      secondary: adminAccent,
      secondaryContainer: Color(0xFF4338CA),
      surface: Color(0xFF1E293B),
      error: adminError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFE2E8F0),
      onError: Colors.white,
    ),
    // Other theme properties similar to employeeDarkTheme but with admin colors
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
