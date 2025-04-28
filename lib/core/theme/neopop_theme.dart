import 'package:flutter/material.dart';

import 'package:next_gen/core/theme/app_theme.dart';

/// Helper class for NeoPOP styling
class NeoPopTheme {
  // Private constructor to prevent instantiation
  NeoPopTheme._();

  /// Primary button style
  static NeoPopButtonStyle primaryButtonStyle({
    required BuildContext context,
    Color? color,
    double depth = 8,
    Color? parentColor,
  }) {
    return _createButtonStyle(
      context: context,
      color: color ?? AppTheme.electricBlue,
      depth: depth,
      parentColor: parentColor,
    );
  }

  /// Secondary button style
  static NeoPopButtonStyle secondaryButtonStyle({
    required BuildContext context,
    Color? color,
    double depth = 5,
    Color? parentColor,
  }) {
    return _createButtonStyle(
      context: context,
      color: color ?? AppTheme.lavender,
      depth: depth,
      parentColor: parentColor,
    );
  }

  /// Danger button style
  static NeoPopButtonStyle dangerButtonStyle({
    required BuildContext context,
    Color? color,
    double depth = 5,
    Color? parentColor,
  }) {
    return _createButtonStyle(
      context: context,
      color: color ?? AppTheme.coralRed,
      depth: depth,
      parentColor: parentColor,
    );
  }

  /// Success button style
  static NeoPopButtonStyle successButtonStyle({
    required BuildContext context,
    Color? color,
    double depth = 5,
    Color? parentColor,
  }) {
    return _createButtonStyle(
      context: context,
      color: color ?? AppTheme.mintGreen,
      depth: depth,
      parentColor: parentColor,
    );
  }

  /// Flat button style
  static NeoPopButtonStyle flatButtonStyle({
    required BuildContext context,
    Color? color,
    Color? parentColor,
  }) {
    final theme = Theme.of(context);
    return NeoPopButtonStyle(
      color: color ?? theme.cardTheme.color ?? Colors.white,
      depth: 0,
      border:
          Border.all(color: AppTheme.slateGray.withAlpha(76)), // 0.3 * 255 = 76
      parentColor: parentColor ?? theme.scaffoldBackgroundColor,
    );
  }

  /// Card style
  static NeoPopCardStyle cardStyle({
    required BuildContext context,
    Color? color,
    double depth = 2,
    Color? parentColor,
  }) {
    final theme = Theme.of(context);
    return NeoPopCardStyle(
      color: color ?? theme.cardTheme.color ?? Colors.white,
      depth: depth,
      border: Border.all(color: Colors.white.withAlpha(51)), // 0.2 * 255 = 51
      parentColor: parentColor ?? theme.scaffoldBackgroundColor,
    );
  }

  /// Helper method to create button style
  static NeoPopButtonStyle _createButtonStyle({
    required BuildContext context,
    required Color color,
    required double depth,
    Color? parentColor,
  }) {
    final theme = Theme.of(context);
    return NeoPopButtonStyle(
      color: color,
      depth: depth,
      border: Border.all(color: Colors.white.withAlpha(51)), // 0.2 * 255 = 51
      parentColor: parentColor ?? theme.scaffoldBackgroundColor,
    );
  }
}

/// Extension for NeoPopButtonStyle
class NeoPopButtonStyle {
  NeoPopButtonStyle({
    required this.color,
    required this.depth,
    required this.parentColor,
    this.border,
    this.grandparentColor,
  });
  final Color color;
  final double depth;
  final Border? border;
  final Color parentColor;
  final Color? grandparentColor;
}

/// Extension for NeoPopCardStyle
class NeoPopCardStyle {
  NeoPopCardStyle({
    required this.color,
    required this.depth,
    required this.parentColor,
    this.border,
    this.grandparentColor,
  });
  final Color color;
  final double depth;
  final Border? border;
  final Color parentColor;
  final Color? grandparentColor;
}
