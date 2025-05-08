import 'package:flutter/material.dart';

/// Extension on ThemeData to provide backward compatibility for deprecated properties
/// and ensure consistent theme access across the app
extension ThemeDataExtensions on ThemeData {
  /// Replacement for the deprecated backgroundColor property
  Color get backgroundColor => colorScheme.surface;

  /// Replacement for the deprecated errorColor property
  Color get errorColor => colorScheme.error;
}

/// Extension on ColorScheme to provide backward compatibility for deprecated properties
/// and ensure consistent color access across the app
extension ColorSchemeExtensions on ColorScheme {
  /// Replacement for the deprecated background property
  Color get background => surface;

  /// Replacement for the deprecated onBackground property
  Color get onBackground => onSurface;
}

/// Extension on TextTheme to provide backward compatibility for deprecated properties
/// and ensure consistent typography access across the app
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
