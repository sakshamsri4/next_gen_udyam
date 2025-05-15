import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/theme/button_theme_helper.dart';

/// A comprehensive button component that adapts to the user's role
///
/// This button supports multiple variants (primary, secondary, outline, text),
/// loading states, disabled states, and icon support.
class NextGenButton extends StatelessWidget {
  /// Creates a primary button
  ///
  /// [text] is the text to display on the button
  /// [onPressed] is the callback when the button is pressed
  /// [isLoading] indicates if the button is in loading state
  /// [isFullWidth] determines if the button should take full width
  /// [size] determines the button size (small, medium, large)
  /// [icon] is an optional icon to display before or after the text
  /// [iconPosition] determines if the icon is before or after the text
  /// [role] overrides the current user role for styling
  /// [borderRadius] customizes the border radius
  /// [elevation] customizes the elevation
  /// [padding] customizes the padding
  /// [textStyle] customizes the text style
  /// [loadingIndicatorColor] customizes the loading indicator color
  /// [loadingIndicatorSize] customizes the loading indicator size
  /// [semanticLabel] provides an accessibility label
  factory NextGenButton.primary({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    IconPosition iconPosition = IconPosition.start,
    UserType? role,
    double? borderRadius,
    double? elevation,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Color? loadingIndicatorColor,
    double loadingIndicatorSize = 24.0,
    String? semanticLabel,
    Key? key,
  }) {
    return NextGenButton._(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.primary,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      icon: icon,
      iconPosition: iconPosition,
      role: role,
      borderRadius: borderRadius,
      elevation: elevation,
      padding: padding,
      textStyle: textStyle,
      loadingIndicatorColor: loadingIndicatorColor,
      loadingIndicatorSize: loadingIndicatorSize,
      semanticLabel: semanticLabel,
      key: key,
    );
  }

  /// Creates a secondary button
  factory NextGenButton.secondary({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    IconPosition iconPosition = IconPosition.start,
    UserType? role,
    double? borderRadius,
    double? elevation,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Color? loadingIndicatorColor,
    double loadingIndicatorSize = 24.0,
    String? semanticLabel,
    Key? key,
  }) {
    return NextGenButton._(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.secondary,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      icon: icon,
      iconPosition: iconPosition,
      role: role,
      borderRadius: borderRadius,
      elevation: elevation,
      padding: padding,
      textStyle: textStyle,
      loadingIndicatorColor: loadingIndicatorColor,
      loadingIndicatorSize: loadingIndicatorSize,
      semanticLabel: semanticLabel,
      key: key,
    );
  }

  /// Creates an outline button
  factory NextGenButton.outline({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    IconPosition iconPosition = IconPosition.start,
    UserType? role,
    double? borderRadius,
    double borderWidth = 1.5,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Color? loadingIndicatorColor,
    double loadingIndicatorSize = 24.0,
    String? semanticLabel,
    Key? key,
  }) {
    return NextGenButton._(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.outline,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      icon: icon,
      iconPosition: iconPosition,
      role: role,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      padding: padding,
      textStyle: textStyle,
      loadingIndicatorColor: loadingIndicatorColor,
      loadingIndicatorSize: loadingIndicatorSize,
      semanticLabel: semanticLabel,
      key: key,
    );
  }

  /// Creates a text button
  factory NextGenButton.text({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    IconPosition iconPosition = IconPosition.start,
    UserType? role,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Color? loadingIndicatorColor,
    double loadingIndicatorSize = 24.0,
    String? semanticLabel,
    Key? key,
  }) {
    return NextGenButton._(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.text,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      icon: icon,
      iconPosition: iconPosition,
      role: role,
      borderRadius: borderRadius,
      padding: padding,
      textStyle: textStyle,
      loadingIndicatorColor: loadingIndicatorColor,
      loadingIndicatorSize: loadingIndicatorSize,
      semanticLabel: semanticLabel,
      key: key,
    );
  }

  /// Creates an icon-only button
  factory NextGenButton.icon({
    required IconData icon,
    required VoidCallback? onPressed,
    ButtonVariant variant = ButtonVariant.primary,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
    UserType? role,
    double? borderRadius,
    double? elevation,
    double? borderWidth,
    EdgeInsetsGeometry? padding,
    Color? loadingIndicatorColor,
    double loadingIndicatorSize = 24.0,
    String? semanticLabel,
    bool isCircular = false,
    Key? key,
  }) {
    return NextGenButton._(
      text: '',
      onPressed: onPressed,
      variant: variant,
      isLoading: isLoading,
      isFullWidth: false,
      size: size,
      icon: icon,
      isIconOnly: true,
      role: role,
      borderRadius: isCircular ? 100 : borderRadius,
      elevation: elevation,
      borderWidth: borderWidth,
      padding: padding,
      loadingIndicatorColor: loadingIndicatorColor,
      loadingIndicatorSize: loadingIndicatorSize,
      semanticLabel: semanticLabel,
      key: key,
    );
  }

  /// Private constructor
  const NextGenButton._({
    required this.text,
    required this.onPressed,
    required this.variant,
    required this.isLoading,
    required this.isFullWidth,
    required this.size,
    this.icon,
    this.iconPosition = IconPosition.start,
    this.isIconOnly = false,
    this.role,
    this.borderRadius,
    this.elevation,
    this.borderWidth,
    this.padding,
    this.textStyle,
    this.loadingIndicatorColor,
    this.loadingIndicatorSize = 24.0,
    this.semanticLabel,
    super.key,
  });

  /// The text to display on the button
  final String text;

  /// The callback when the button is pressed
  final VoidCallback? onPressed;

  /// The button variant
  final ButtonVariant variant;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Whether the button should take full width
  final bool isFullWidth;

  /// The button size
  final ButtonSize size;

  /// Optional icon to display
  final IconData? icon;

  /// Position of the icon
  final IconPosition iconPosition;

  /// Whether the button is icon-only
  final bool isIconOnly;

  /// Override the current user role for styling
  final UserType? role;

  /// Custom border radius
  final double? borderRadius;

  /// Custom elevation
  final double? elevation;

  /// Custom border width for outline buttons
  final double? borderWidth;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Custom text style
  final TextStyle? textStyle;

  /// Custom loading indicator color
  final Color? loadingIndicatorColor;

  /// Custom loading indicator size
  final double loadingIndicatorSize;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get user role
    var userRole = role;
    if (userRole == null) {
      try {
        // Try to get from AuthController
        if (Get.isRegistered<AuthController>()) {
          final authController = Get.find<AuthController>();
          if (authController.selectedRole.value != null) {
            userRole = authController.selectedRole.value;
          }
        }
      } catch (e) {
        // Log error but continue with default styling
        try {
          Get.find<LoggerService>().w('Error getting user role for button: $e');
        } catch (_) {
          // Ignore if logger is not available
        }
      }
    }

    // Get button style based on variant
    ButtonStyle buttonStyle;
    switch (variant) {
      case ButtonVariant.primary:
        buttonStyle = ButtonThemeHelper.getPrimaryStyle(
          role: userRole,
          isDarkMode: isDarkMode,
          size: size,
          elevation: elevation,
          borderRadius: borderRadius ?? ButtonThemeHelper.defaultBorderRadius,
          padding: padding,
        );
      case ButtonVariant.secondary:
        buttonStyle = ButtonThemeHelper.getSecondaryStyle(
          role: userRole,
          isDarkMode: isDarkMode,
          size: size,
          elevation: elevation,
          borderRadius: borderRadius ?? ButtonThemeHelper.defaultBorderRadius,
          padding: padding,
        );
      case ButtonVariant.outline:
        buttonStyle = ButtonThemeHelper.getOutlineStyle(
          role: userRole,
          isDarkMode: isDarkMode,
          size: size,
          borderRadius: borderRadius ?? ButtonThemeHelper.defaultBorderRadius,
          padding: padding,
          borderWidth: borderWidth ?? 1.5,
        );
      case ButtonVariant.text:
        buttonStyle = ButtonThemeHelper.getTextStyle(
          role: userRole,
          isDarkMode: isDarkMode,
          size: size,
          borderRadius: borderRadius ?? ButtonThemeHelper.defaultBorderRadius,
          padding: padding,
        );
    }

    // Create the button
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: Semantics(
        button: true,
        enabled: onPressed != null && !isLoading,
        label: semanticLabel ?? text,
        child: _buildButton(buttonStyle, userRole, isDarkMode),
      ),
    );
  }

  /// Build the button with the appropriate style
  Widget _buildButton(
    ButtonStyle buttonStyle,
    UserType? userRole,
    bool isDarkMode,
  ) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: _buildButtonContent(userRole, isDarkMode),
    );
  }

  /// Build the button content (text, icon, loading indicator)
  Widget _buildButtonContent(UserType? userRole, bool isDarkMode) {
    if (isLoading) {
      return SizedBox(
        width: loadingIndicatorSize,
        height: loadingIndicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            loadingIndicatorColor ??
                _getLoadingIndicatorColor(userRole, isDarkMode),
          ),
        ),
      );
    }

    if (isIconOnly && icon != null) {
      return Icon(icon);
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: iconPosition == IconPosition.start
            ? [
                Icon(icon, size: _getIconSize()),
                SizedBox(width: _getIconSpacing()),
                Text(text, style: textStyle),
              ]
            : [
                Text(text, style: textStyle),
                SizedBox(width: _getIconSpacing()),
                Icon(icon, size: _getIconSize()),
              ],
      );
    }

    return Text(text, style: textStyle);
  }

  /// Get the loading indicator color based on variant and role
  Color _getLoadingIndicatorColor(UserType? userRole, bool isDarkMode) {
    final primaryColor = ButtonThemeHelper.getPrimaryColor(userRole);
    final primaryLightColor = ButtonThemeHelper.getPrimaryLightColor(userRole);

    switch (variant) {
      case ButtonVariant.primary:
        return Colors.white;
      case ButtonVariant.secondary:
        return isDarkMode ? Colors.white : primaryColor;
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return isDarkMode ? primaryLightColor : primaryColor;
    }
  }

  /// Get icon size based on button size
  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
      case ButtonSize.custom:
        return 20;
    }
  }

  /// Get spacing between icon and text
  double _getIconSpacing() {
    switch (size) {
      case ButtonSize.small:
        return 6;
      case ButtonSize.medium:
        return 8;
      case ButtonSize.large:
        return 12;
      case ButtonSize.custom:
        return 8;
    }
  }
}

/// Icon position enum
enum IconPosition {
  /// Icon before text
  start,

  /// Icon after text
  end,
}
