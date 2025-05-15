import 'package:flutter/material.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// Button variants
enum ButtonVariant {
  /// Primary button with filled background
  primary,

  /// Secondary button with lighter background
  secondary,

  /// Outline button with transparent background and colored border
  outline,

  /// Text button with no background or border
  text,
}

/// Button sizes
enum ButtonSize {
  /// Small button
  small,

  /// Medium button (default)
  medium,

  /// Large button
  large,

  /// Custom size
  custom,
}

/// Helper class for button styling
class ButtonThemeHelper {
  // Private constructor to prevent instantiation
  ButtonThemeHelper._();

  /// Default border radius for buttons
  static const double defaultBorderRadius = 8;

  /// Default elevation for primary buttons
  static const double primaryElevation = 2;

  /// Default elevation for secondary buttons
  static const double secondaryElevation = 1;

  /// Default padding for small buttons
  static const EdgeInsetsGeometry smallPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  /// Default padding for medium buttons
  static const EdgeInsetsGeometry mediumPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 12);

  /// Default padding for large buttons
  static const EdgeInsetsGeometry largePadding =
      EdgeInsets.symmetric(horizontal: 32, vertical: 16);

  /// Get primary color for the given role
  static Color getPrimaryColor(UserType? role) {
    switch (role) {
      case UserType.employee:
        return RoleThemes.employeePrimary;
      case UserType.employer:
        return RoleThemes.employerPrimary;
      case UserType.admin:
        return RoleThemes.adminPrimary;
      case null:
        return RoleThemes.employeePrimary; // Default to employee
    }
  }

  /// Get primary light color for the given role
  static Color getPrimaryLightColor(UserType? role) {
    switch (role) {
      case UserType.employee:
        return RoleThemes.employeePrimaryLight;
      case UserType.employer:
        return RoleThemes.employerPrimaryLight;
      case UserType.admin:
        return RoleThemes.adminPrimaryLight;
      case null:
        return RoleThemes.employeePrimaryLight; // Default to employee
    }
  }

  /// Get secondary color for the given role
  static Color getSecondaryColor(UserType? role) {
    switch (role) {
      case UserType.employee:
        return RoleThemes.employeeAccent;
      case UserType.employer:
        return RoleThemes.employerAccent;
      case UserType.admin:
        return RoleThemes.adminAccent;
      case null:
        return RoleThemes.employeeAccent; // Default to employee
    }
  }

  /// Get padding based on button size
  static EdgeInsetsGeometry getPadding(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return smallPadding;
      case ButtonSize.medium:
        return mediumPadding;
      case ButtonSize.large:
        return largePadding;
      case ButtonSize.custom:
        return mediumPadding; // Default to medium if custom
    }
  }

  /// Get button style for primary variant
  static ButtonStyle getPrimaryStyle({
    required UserType? role,
    required bool isDarkMode,
    ButtonSize size = ButtonSize.medium,
    double? elevation,
    double borderRadius = defaultBorderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    final primaryColor = getPrimaryColor(role);
    const foregroundColor = Colors.white;

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return primaryColor.withOpacity(0.5);
        }
        if (states.contains(WidgetState.pressed)) {
          return Color.lerp(primaryColor, Colors.black, 0.1) ?? primaryColor;
        }
        if (states.contains(WidgetState.hovered)) {
          return Color.lerp(primaryColor, Colors.white, 0.1) ?? primaryColor;
        }
        return primaryColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return foregroundColor.withOpacity(0.7);
        }
        return foregroundColor;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withOpacity(0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return Colors.white.withOpacity(0.05);
        }
        return null;
      }),
      elevation: WidgetStateProperty.resolveWith<double>((states) {
        if (states.contains(WidgetState.disabled)) {
          return 0;
        }
        if (states.contains(WidgetState.pressed)) {
          return (elevation ?? primaryElevation) - 1;
        }
        return elevation ?? primaryElevation;
      }),
      padding: WidgetStateProperty.all(padding ?? getPadding(size)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Get button style for secondary variant
  static ButtonStyle getSecondaryStyle({
    required UserType? role,
    required bool isDarkMode,
    ButtonSize size = ButtonSize.medium,
    double? elevation,
    double borderRadius = defaultBorderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    final primaryColor = getPrimaryColor(role);
    final secondaryColor = getSecondaryColor(role);
    final backgroundColor = isDarkMode
        ? secondaryColor.withOpacity(0.2)
        : secondaryColor.withOpacity(0.15);
    final foregroundColor = isDarkMode ? Colors.white : primaryColor;

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return backgroundColor.withOpacity(0.5);
        }
        if (states.contains(WidgetState.pressed)) {
          return Color.lerp(backgroundColor, Colors.black, 0.05) ??
              backgroundColor;
        }
        if (states.contains(WidgetState.hovered)) {
          return Color.lerp(backgroundColor, Colors.white, 0.1) ??
              backgroundColor;
        }
        return backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return foregroundColor.withOpacity(0.7);
        }
        return foregroundColor;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return primaryColor.withOpacity(0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return primaryColor.withOpacity(0.05);
        }
        return null;
      }),
      elevation: WidgetStateProperty.resolveWith<double>((states) {
        if (states.contains(WidgetState.disabled)) {
          return 0;
        }
        if (states.contains(WidgetState.pressed)) {
          return (elevation ?? secondaryElevation) - 0.5;
        }
        return elevation ?? secondaryElevation;
      }),
      padding: WidgetStateProperty.all(padding ?? getPadding(size)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Get button style for outline variant
  static ButtonStyle getOutlineStyle({
    required UserType? role,
    required bool isDarkMode,
    ButtonSize size = ButtonSize.medium,
    double borderRadius = defaultBorderRadius,
    EdgeInsetsGeometry? padding,
    double borderWidth = 1.5,
  }) {
    final primaryColor = getPrimaryColor(role);
    final primaryLightColor = getPrimaryLightColor(role);
    final borderColor = isDarkMode ? primaryLightColor : primaryColor;
    final foregroundColor = isDarkMode ? primaryLightColor : primaryColor;

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return borderColor.withOpacity(0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return borderColor.withOpacity(0.05);
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return foregroundColor.withOpacity(0.5);
        }
        return foregroundColor;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return borderColor.withOpacity(0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return borderColor.withOpacity(0.05);
        }
        return null;
      }),
      side: WidgetStateProperty.resolveWith<BorderSide>((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: borderColor.withOpacity(0.5),
            width: borderWidth,
          );
        }
        return BorderSide(color: borderColor, width: borderWidth);
      }),
      elevation: WidgetStateProperty.all(0),
      padding: WidgetStateProperty.all(padding ?? getPadding(size)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Get button style for text variant
  static ButtonStyle getTextStyle({
    required UserType? role,
    required bool isDarkMode,
    ButtonSize size = ButtonSize.medium,
    double borderRadius = defaultBorderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    final primaryColor = getPrimaryColor(role);
    final primaryLightColor = getPrimaryLightColor(role);
    final foregroundColor = isDarkMode ? primaryLightColor : primaryColor;

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return foregroundColor.withOpacity(0.5);
        }
        return foregroundColor;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return foregroundColor.withOpacity(0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return foregroundColor.withOpacity(0.05);
        }
        return null;
      }),
      elevation: WidgetStateProperty.all(0),
      padding: WidgetStateProperty.all(padding ?? getPadding(size)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
