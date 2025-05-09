import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// A custom NeoPop button component
class CustomNeoPopButton extends StatelessWidget {
  /// Creates a primary custom NeoPop button
  ///
  /// [onTap] is called when the button is tapped
  /// [child] is the widget to display inside the button
  factory CustomNeoPopButton.primary({
    required VoidCallback? onTap,
    required Widget child,
    Key? key,
  }) {
    return CustomNeoPopButton._(
      onTap: onTap,
      color: AppTheme.electricBlue,
      textColor: Colors.white,
      key: key,
      child: child,
    );
  }

  /// Creates a secondary custom NeoPop button
  ///
  /// [onTap] is called when the button is tapped
  /// [child] is the widget to display inside the button
  factory CustomNeoPopButton.secondary({
    required VoidCallback? onTap,
    required Widget child,
    Key? key,
  }) {
    return CustomNeoPopButton._(
      onTap: onTap,
      color: Colors.white,
      textColor: AppTheme.electricBlue,
      key: key,
      child: child,
    );
  }

  /// Creates a danger custom NeoPop button
  ///
  /// [onTap] is called when the button is tapped
  /// [child] is the widget to display inside the button
  factory CustomNeoPopButton.danger({
    required VoidCallback? onTap,
    required Widget child,
    Key? key,
  }) {
    return CustomNeoPopButton._(
      onTap: onTap,
      color: Colors.red,
      textColor: Colors.white,
      key: key,
      child: child,
    );
  }

  /// Creates a custom NeoPop button
  ///
  /// [onTap] is called when the button is tapped
  /// [child] is the widget to display inside the button
  /// [color] is the background color of the button
  /// [textColor] is the color of the text inside the button
  const CustomNeoPopButton._({
    required this.onTap,
    required this.child,
    required this.color,
    required this.textColor,
    super.key,
  });

  /// Called when the button is tapped
  final VoidCallback? onTap;

  /// The widget to display inside the button
  final Widget child;

  /// The background color of the button
  final Color color;

  /// The color of the text inside the button
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return NeoPopButton(
      color: color,
      onTapUp: onTap,
      onTapDown: () => {},
      enabled: onTap != null,
      child: child,
    );
  }
}
