import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// A custom button following CRED design principles
///
/// This button implements CRED design principles with pill-shaped design,
/// elevation, subtle animations, and haptic feedback.
class CredButton extends StatelessWidget {
  /// Creates a custom button with CRED design
  ///
  /// [title] is the text to display on the button
  /// [onTap] is the function to call when the button is tapped
  /// [backgroundColor] is the background color of the button
  /// (defaults to theme primary color)
  /// [foregroundColor] is the text color of the button (defaults to white)
  /// [elevation] is the elevation of the button (defaults to 8)
  /// [borderRadius] is the border radius of the button
  /// (defaults to 28 for pill shape)
  /// [height] is the height of the button (defaults to 56)
  /// [isFullWidth] determines if the button should take full width
  /// (defaults to true)
  /// [icon] is an optional icon to display before the text
  /// [isLoading] controls the loading state of the button
  const CredButton({
    required this.title,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.elevation = 8,
    this.borderRadius = 28,
    this.height = 56,
    this.isFullWidth = true,
    this.icon,
    this.isLoading = false,
    super.key,
  });

  /// Factory constructor for creating a primary button
  factory CredButton.primary({
    required String title,
    required VoidCallback onTap,
    bool isFullWidth = true,
    IconData? icon,
    double elevation = 8,
    bool isLoading = false,
    Key? key,
  }) {
    return CredButton(
      title: title,
      onTap: onTap,
      isFullWidth: isFullWidth,
      icon: icon,
      elevation: elevation,
      isLoading: isLoading,
      key: key,
    );
  }

  /// Factory constructor for creating a secondary button
  factory CredButton.secondary({
    required String title,
    required VoidCallback onTap,
    bool isFullWidth = true,
    IconData? icon,
    double elevation = 5,
    bool isLoading = false,
    Key? key,
  }) {
    return CredButton(
      title: title,
      onTap: onTap,
      backgroundColor: Get.theme.colorScheme.secondary,
      isFullWidth: isFullWidth,
      icon: icon,
      elevation: elevation,
      isLoading: isLoading,
      key: key,
    );
  }

  /// Factory constructor for creating a danger button
  factory CredButton.danger({
    required String title,
    required VoidCallback onTap,
    bool isFullWidth = true,
    IconData? icon,
    double elevation = 5,
    bool isLoading = false,
    Key? key,
  }) {
    return CredButton(
      title: title,
      onTap: onTap,
      backgroundColor: Get.theme.colorScheme.error,
      isFullWidth: isFullWidth,
      icon: icon,
      elevation: elevation,
      isLoading: isLoading,
      key: key,
    );
  }

  /// Factory constructor for creating a success button
  factory CredButton.success({
    required String title,
    required VoidCallback onTap,
    bool isFullWidth = true,
    IconData? icon,
    double elevation = 5,
    bool isLoading = false,
    Key? key,
  }) {
    const successColor = Color(0xFF00A651); // Mint green from AppTheme
    return CredButton(
      title: title,
      onTap: onTap,
      backgroundColor: successColor,
      isFullWidth: isFullWidth,
      icon: icon,
      elevation: elevation,
      isLoading: isLoading,
      key: key,
    );
  }

  /// Factory constructor for creating a flat button with border
  factory CredButton.outline({
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    bool isFullWidth = true,
    IconData? icon,
    bool isLoading = false,
    Key? key,
  }) {
    final theme = Get.theme;
    final text = textColor ?? theme.colorScheme.primary;

    return CredButton(
      title: title,
      onTap: onTap,
      backgroundColor: Colors.transparent,
      foregroundColor: text,
      elevation: 0,
      isFullWidth: isFullWidth,
      icon: icon,
      isLoading: isLoading,
      key: key,
    );
  }

  /// The text to display on the button
  final String title;

  /// The function to call when the button is tapped
  final VoidCallback onTap;

  /// The background color of the button
  final Color? backgroundColor;

  /// The text color of the button
  final Color foregroundColor;

  /// The elevation of the button
  final double elevation;

  /// The border radius of the button
  final double borderRadius;

  /// The height of the button
  final double height;

  /// Whether the button should take full width
  final bool isFullWidth;

  /// Optional icon to display before the text
  final IconData? icon;

  /// Whether the button is in loading state
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonSize = 20.h;
    final bgColor = backgroundColor ?? theme.colorScheme.primary;

    return Container(
      width: isFullWidth ? double.infinity : null,
      height: height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: [
          BoxShadow(
            color: bgColor.withAlpha(76), // 0.3 * 255 = 76
            blurRadius: elevation,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading
              ? null
              : () {
                  // Add haptic feedback for physical sensation
                  HapticFeedback.mediumImpact();
                  onTap();
                },
          borderRadius: BorderRadius.circular(borderRadius.r),
          splashColor: foregroundColor.withAlpha(25), // 0.1 opacity
          highlightColor: foregroundColor.withAlpha(13), // 0.05 opacity
          child: Ink(
            decoration: BoxDecoration(
              color: isLoading
                  ? bgColor.withAlpha(204) // 0.8 opacity
                  : bgColor,
              borderRadius: BorderRadius.circular(borderRadius.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  bgColor,
                  Color.lerp(bgColor, Colors.black, 0.1) ?? bgColor,
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isLoading
                      ? SizedBox(
                          height: buttonSize,
                          width: buttonSize,
                          child: CircularProgressIndicator(
                            color: foregroundColor,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisSize:
                              isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (icon != null) ...[
                              Icon(icon, color: foregroundColor, size: 20.sp),
                              SizedBox(width: 8.w),
                            ],
                            Text(
                              title,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: foregroundColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
