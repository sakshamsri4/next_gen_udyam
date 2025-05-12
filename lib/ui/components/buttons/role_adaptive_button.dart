import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A button that adapts its styling based on the user's role
class RoleAdaptiveButton extends StatelessWidget {
  /// Creates a role-adaptive button
  const RoleAdaptiveButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.textStyle,
    this.borderRadius,
    this.elevation,
  });

  /// The text to display on the button
  final String text;

  /// The callback to execute when the button is pressed
  final VoidCallback onPressed;

  /// Whether the button is in a loading state
  final bool isLoading;

  /// Whether to use an outlined style
  final bool isOutlined;

  /// Optional icon to display before the text
  final IconData? icon;

  /// Optional padding for the button
  final EdgeInsetsGeometry? padding;

  /// Optional text style for the button text
  final TextStyle? textStyle;

  /// Optional border radius for the button
  final BorderRadius? borderRadius;

  /// Optional elevation for the button
  final double? elevation;

  /// Optional width for the button
  final double? width;

  /// Optional height for the button
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get user role
    UserType? userRole;
    try {
      // Try to get from AuthController first
      if (Get.isRegistered<AuthController>()) {
        final authController = Get.find<AuthController>();
        if (authController.selectedRole.value != null) {
          userRole = authController.selectedRole.value;
        } else {
          // If no selected role, try to get from auth service
          if (Get.isRegistered<AuthService>()) {
            final authService = Get.find<AuthService>();
            authService.getUserFromFirebase().then((userModel) {
              if (userModel != null && userModel.userType != null) {
                userRole = userModel.userType;
              }
            });
          }
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

    // Apply role-specific styling
    Color buttonColor;
    Color textColor;

    if (userRole == UserType.employee) {
      buttonColor = RoleThemes.employeePrimary;
      textColor = Colors.white;
    } else if (userRole == UserType.employer) {
      buttonColor = RoleThemes.employerPrimary;
      textColor = Colors.white;
    } else if (userRole == UserType.admin) {
      buttonColor = RoleThemes.adminPrimary;
      textColor = Colors.white;
    } else {
      // Default to theme's primary color if no role is set
      buttonColor = theme.primaryColor;
      textColor = theme.primaryColor.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white;
    }

    // Create the button based on the outlined flag
    if (isOutlined) {
      return _buildOutlinedButton(buttonColor, textColor);
    } else {
      return _buildElevatedButton(buttonColor, textColor);
    }
  }

  /// Build an outlined button with role-specific styling
  Widget _buildOutlinedButton(Color buttonColor, Color textColor) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: buttonColor),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
      child: _buildButtonContent(buttonColor, textColor),
    );
  }

  /// Build an elevated button with role-specific styling
  Widget _buildElevatedButton(Color buttonColor, Color textColor) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: textColor,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        elevation: elevation ?? 2,
      ),
      child: _buildButtonContent(buttonColor, textColor),
    );
  }

  /// Build the button content (text, icon, loading indicator)
  Widget _buildButtonContent(Color buttonColor, Color textColor) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? buttonColor : textColor,
          ),
          strokeWidth: 2,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isOutlined ? buttonColor : textColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: textStyle ??
                TextStyle(
                  color: isOutlined ? buttonColor : textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: textStyle ??
          TextStyle(
            color: isOutlined ? buttonColor : textColor,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
