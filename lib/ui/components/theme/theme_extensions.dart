import 'package:flutter/material.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/core/theme/complete_role_themes.dart';

/// Extension on ThemeData to provide backward compatibility for deprecated
/// properties and ensure consistent theme access across the app
extension ThemeDataExtensions on ThemeData {
  /// Replacement for the deprecated backgroundColor property
  Color get backgroundColor => colorScheme.surface;

  /// Replacement for the deprecated errorColor property
  Color get errorColor => colorScheme.error;

  /// Get semantic success color
  Color get successColor => RoleThemes.successColor;

  /// Get semantic warning color
  Color get warningColor => RoleThemes.warningColor;

  /// Get semantic info color
  Color get infoColor => RoleThemes.infoColor;

  /// Get role-specific primary color based on brightness
  Color get rolePrimaryColor {
    // Compare colors using their ARGB values
    final isPrimaryBlue =
        colorScheme.primary.toARGB32() == RoleThemes.employeePrimary.toARGB32();
    final isPrimaryGreen =
        colorScheme.primary.toARGB32() == RoleThemes.employerPrimary.toARGB32();
    final isPrimaryIndigo =
        colorScheme.primary.toARGB32() == RoleThemes.adminPrimary.toARGB32();

    if (isPrimaryBlue) {
      return brightness == Brightness.light
          ? RoleThemes.employeePrimary
          : RoleThemes.employeePrimaryLight;
    } else if (isPrimaryGreen) {
      return brightness == Brightness.light
          ? RoleThemes.employerPrimary
          : RoleThemes.employerPrimaryLight;
    } else if (isPrimaryIndigo) {
      return brightness == Brightness.light
          ? RoleThemes.adminPrimary
          : RoleThemes.adminPrimaryLight;
    }

    // Default to employee colors if no match
    return brightness == Brightness.light
        ? RoleThemes.employeePrimary
        : RoleThemes.employeePrimaryLight;
  }

  /// Get user role from theme
  UserType? get userRole {
    // Compare colors using their ARGB values
    final isPrimaryBlue =
        colorScheme.primary.toARGB32() == RoleThemes.employeePrimary.toARGB32();
    final isPrimaryGreen =
        colorScheme.primary.toARGB32() == RoleThemes.employerPrimary.toARGB32();
    final isPrimaryIndigo =
        colorScheme.primary.toARGB32() == RoleThemes.adminPrimary.toARGB32();

    if (isPrimaryBlue) {
      return UserType.employee;
    } else if (isPrimaryGreen) {
      return UserType.employer;
    } else if (isPrimaryIndigo) {
      return UserType.admin;
    }

    return null;
  }
}

/// Extension on ColorScheme to provide backward compatibility for deprecated
/// properties and ensure consistent color access across the app
extension ColorSchemeExtensions on ColorScheme {
  /// Replacement for the deprecated background property
  Color get background => surface;

  /// Replacement for the deprecated onBackground property
  Color get onBackground => onSurface;

  /// Get semantic success color
  Color get success => RoleThemes.successColor;

  /// Get semantic warning color
  Color get warning => RoleThemes.warningColor;

  /// Get semantic info color
  Color get info => RoleThemes.infoColor;
}

/// Extension on TextTheme to provide backward compatibility for deprecated
/// properties and ensure consistent typography access across the app
extension TextThemeExtensions on TextTheme {
  /// Replacement for the deprecated headline6 property
  TextStyle? get headline6 => titleLarge;

  /// Replacement for the deprecated subtitle1 property
  TextStyle? get subtitle1 => titleMedium;

  /// Replacement for the deprecated button property
  TextStyle? get button => labelLarge;

  /// Replacement for the deprecated caption property
  TextStyle? get caption => bodySmall;
}

/// Extension on BuildContext to provide easy access to theme properties
extension BuildContextExtensions on BuildContext {
  /// Get theme data
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get primary color
  Color get primaryColor => Theme.of(this).colorScheme.primary;

  /// Get role-specific primary color
  Color get rolePrimaryColor => Theme.of(this).rolePrimaryColor;

  /// Get success color
  Color get successColor => Theme.of(this).successColor;

  /// Get warning color
  Color get warningColor => Theme.of(this).warningColor;

  /// Get info color
  Color get infoColor => Theme.of(this).infoColor;

  /// Get error color
  Color get errorColor => Theme.of(this).colorScheme.error;

  /// Get user role from theme
  UserType? get userRole => Theme.of(this).userRole;
}
