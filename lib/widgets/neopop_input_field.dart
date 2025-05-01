import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// A custom input field widget using NeoPOP design.
///
/// This widget provides a consistent styling for input fields in the app
/// with NeoPOP-inspired design elements.
class NeoPopInputField extends StatefulWidget {
  /// Creates a NeoPopInputField.
  ///
  /// The [controller] and [labelText] parameters are required.
  const NeoPopInputField({
    required this.controller,
    required this.labelText,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.focusNode,
    super.key,
  });

  /// The controller for the input field.
  final TextEditingController controller;

  /// The label text for the input field.
  final String labelText;

  /// The hint text for the input field.
  final String? hintText;

  /// The error text for the input field.
  final String? errorText;

  /// The prefix icon for the input field.
  final Widget? prefixIcon;

  /// The suffix icon for the input field.
  final Widget? suffixIcon;

  /// Whether to obscure the text in the input field.
  final bool obscureText;

  /// The keyboard type for the input field.
  final TextInputType keyboardType;

  /// The text input action for the input field.
  final TextInputAction textInputAction;

  /// The callback that is called when the text changes.
  final ValueChanged<String>? onChanged;

  /// The callback that is called when the user submits the input field.
  final ValueChanged<String>? onSubmitted;

  /// The validator for the input field.
  final FormFieldValidator<String>? validator;

  /// Whether the input field is enabled.
  final bool enabled;

  /// Whether the input field should autofocus.
  final bool autofocus;

  /// The maximum number of lines for the input field.
  final int? maxLines;

  /// The minimum number of lines for the input field.
  final int? minLines;

  /// The maximum length of the input field.
  final int? maxLength;

  /// The input formatters for the input field.
  final List<TextInputFormatter>? inputFormatters;

  /// The auto-validate mode for the input field.
  final AutovalidateMode autovalidateMode;

  /// The focus node for the input field.
  final FocusNode? focusNode;

  @override
  State<NeoPopInputField> createState() => _NeoPopInputFieldState();
}

class _NeoPopInputFieldState extends State<NeoPopInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define colors based on theme
    final fillColor = isDarkMode ? AppTheme.darkSurface2 : Colors.white;

    final borderColor = _isFocused
        ? (isDarkMode ? AppTheme.brightElectricBlue : AppTheme.electricBlue)
        : (isDarkMode ? AppTheme.darkSlateGray : AppTheme.slateGray);

    final shadowColor =
        isDarkMode ? Colors.black.withAlpha(100) : Colors.grey.withAlpha(50);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.errorText != null && widget.errorText!.isNotEmpty
              ? (isDarkMode ? AppTheme.neonPink : AppTheme.coralRed)
              : borderColor,
          width: _isFocused ? 2 : 1.5,
        ),
        boxShadow: [
          if (_isFocused)
            BoxShadow(
              color: shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        validator: widget.validator,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        autovalidateMode: widget.autovalidateMode,
        style: TextStyle(
          color: isDarkMode ? AppTheme.offWhite : AppTheme.navyBlue,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          labelStyle: TextStyle(
            color: _isFocused
                ? (isDarkMode
                    ? AppTheme.brightElectricBlue
                    : AppTheme.electricBlue)
                : (isDarkMode ? AppTheme.slateGray : AppTheme.slateGray),
            fontWeight: _isFocused ? FontWeight.bold : FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: isDarkMode
                ? AppTheme.slateGray.withAlpha(179)
                : AppTheme.slateGray.withAlpha(179),
          ),
          errorStyle: TextStyle(
            color: isDarkMode ? AppTheme.neonPink : AppTheme.coralRed,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
