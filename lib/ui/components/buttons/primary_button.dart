import 'package:flutter/material.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A primary button component for the application
class PrimaryButton extends StatelessWidget {
  /// Creates a primary button
  ///
  /// [text] is the text to display on the button
  /// [onPressed] is the callback when the button is pressed
  /// [width] is the width of the button (defaults to null for auto-sizing)
  /// [color] is the background color of the button (defaults to theme primary color)
  /// [textColor] is the color of the text (defaults to white)
  const PrimaryButton({
    required this.text,
    required this.onPressed,
    this.width,
    this.color,
    this.textColor = Colors.white,
    super.key,
  });

  /// The text to display on the button
  final String text;

  /// The callback when the button is pressed
  final VoidCallback onPressed;

  /// The width of the button
  final double? width;

  /// The background color of the button
  final Color? color;

  /// The color of the text
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? RoleThemes.adminPrimary;

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
