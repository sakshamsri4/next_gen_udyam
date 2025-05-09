import 'package:flutter/material.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// A custom input field component
class NeoPopInputField extends StatelessWidget {
  /// Creates a custom input field
  ///
  /// [controller] is the text editing controller
  /// [labelText] is the label text for the field
  /// [hintText] is the hint text for the field
  /// [prefixIcon] is the icon to display at the start of the field
  /// [errorText] is the error text to display below the field
  /// [keyboardType] is the keyboard type to use
  /// [obscureText] is whether to obscure the text
  /// [onChanged] is called when the text changes
  /// [enabled] is whether the field is enabled
  /// [suffixIcon] is the icon to display at the end of the field
  const NeoPopInputField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.enabled = true,
    this.suffixIcon,
    super.key,
  });

  /// The text editing controller
  final TextEditingController controller;

  /// The label text for the field
  final String labelText;

  /// The hint text for the field
  final String hintText;

  /// The icon to display at the start of the field
  final Widget? prefixIcon;

  /// The error text to display below the field
  final String? errorText;

  /// The keyboard type to use
  final TextInputType? keyboardType;

  /// Whether to obscure the text
  final bool obscureText;

  /// Called when the text changes
  final void Function(String)? onChanged;

  /// Whether the field is enabled
  final bool enabled;

  /// The icon to display at the end of the field
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (labelText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              labelText,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: enabled
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withAlpha(128),
              ),
            ),
          ),

        // Input Field
        TextField(
          controller: controller,
          enabled: enabled,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(128),
            ),
            errorText: errorText,
            errorStyle: TextStyle(
              color: theme.colorScheme.error,
              fontSize: 12,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null
                    ? theme.colorScheme.error
                    : isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null
                    ? theme.colorScheme.error
                    : isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null
                    ? theme.colorScheme.error
                    : AppTheme.electricBlue,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
            ),
            fillColor: enabled
                ? isDarkMode
                    ? Colors.grey.shade900
                    : Colors.white
                : isDarkMode
                    ? Colors.grey.shade800
                    : Colors.grey.shade100,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
