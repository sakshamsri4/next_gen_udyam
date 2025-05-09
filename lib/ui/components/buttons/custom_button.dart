import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// A custom button with loading state following CRED design principles
///
/// This button shows a loading indicator when the async action is in progress
/// and follows CRED design principles with pill-shaped design, elevation,
/// and subtle animations.
class CustomButton extends StatelessWidget {
  /// Creates a custom button with loading state
  ///
  /// [title] is the text to display on the button
  /// [onTap] is the async function to call when the button is tapped
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
  /// [loadingColor] is the color of the loading indicator
  /// (defaults to foregroundColor)
  CustomButton({
    required this.title,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.elevation = 8,
    this.borderRadius = 28,
    this.height = 56,
    this.isFullWidth = true,
    this.icon,
    this.loadingColor,
    super.key,
  });

  /// Factory constructor for creating a primary button
  factory CustomButton.primary({
    required String title,
    required Future<void> Function() onTap,
    bool isFullWidth = true,
    IconData? icon,
    double elevation = 8,
    Key? key,
  }) {
    return CustomButton(
      title: title,
      onTap: onTap,
      isFullWidth: isFullWidth,
      icon: icon,
      elevation: elevation,
      key: key,
    );
  }

  /// Factory constructor for creating a secondary button
  factory CustomButton.secondary({
    required String title,
    required Future<void> Function() onTap,
    bool isFullWidth = true,
    IconData? icon,
    double elevation = 5,
    Key? key,
  }) {
    return CustomButton(
      title: title,
      onTap: onTap,
      backgroundColor: Get.theme.colorScheme.secondary,
      isFullWidth: isFullWidth,
      icon: icon,
      elevation: elevation,
      key: key,
    );
  }

  /// Factory constructor for creating a danger button
  factory CustomButton.danger({
    required String title,
    required Future<void> Function() onTap,
    bool isFullWidth = true,
    IconData? icon,
    double elevation = 5,
    Key? key,
  }) {
    return CustomButton(
      title: title,
      onTap: onTap,
      backgroundColor: Get.theme.colorScheme.error,
      isFullWidth: isFullWidth,
      icon: icon,
      elevation: elevation,
      key: key,
    );
  }

  /// Factory constructor for creating a success button
  factory CustomButton.success({
    required String title,
    required Future<void> Function() onTap,
    bool isFullWidth = true,
    IconData? icon,
    double elevation = 5,
    Key? key,
  }) {
    const successColor = Color(0xFF00A651); // Mint green from AppTheme
    return CustomButton(
      title: title,
      onTap: onTap,
      backgroundColor: successColor,
      isFullWidth: isFullWidth,
      icon: icon,
      elevation: elevation,
      key: key,
    );
  }

  /// Factory constructor for creating a flat button with border
  factory CustomButton.outline({
    required String title,
    required Future<void> Function() onTap,
    Color? textColor,
    bool isFullWidth = true,
    IconData? icon,
    Key? key,
  }) {
    final theme = Get.theme;
    final text = textColor ?? theme.colorScheme.primary;

    return CustomButton(
      title: title,
      onTap: onTap,
      backgroundColor: Colors.transparent,
      foregroundColor: text,
      elevation: 0,
      isFullWidth: isFullWidth,
      icon: icon,
      key: key,
    );
  }

  /// The text to display on the button
  final String title;

  /// The async function to call when the button is tapped
  final Future<void> Function() onTap;

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

  /// The color of the loading indicator
  final Color? loadingColor;

  /// Whether the button is in loading state
  final RxBool _isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonSize = 20.h;
    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final loadingIndicatorColor = loadingColor ?? foregroundColor;

    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isFullWidth ? double.infinity : null,
        height: height.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius.r),
          boxShadow: [
            BoxShadow(
              color: bgColor.withAlpha((0.3 * 255).toInt()),
              blurRadius: elevation,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isLoading.value
                ? null
                : () async {
                    // Add haptic feedback for physical sensation
                    await HapticFeedback.mediumImpact();

                    _isLoading.value = true;
                    try {
                      await onTap();
                    } finally {
                      _isLoading.value = false;
                    }
                  },
            borderRadius: BorderRadius.circular(borderRadius.r),
            splashColor: foregroundColor.withAlpha((0.1 * 255).toInt()),
            highlightColor: foregroundColor.withAlpha((0.05 * 255).toInt()),
            child: Ink(
              decoration: BoxDecoration(
                color: _isLoading.value
                    ? bgColor.withAlpha((0.8 * 255).toInt())
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
                  child: _isLoading.value
                      ? SizedBox(
                          height: buttonSize,
                          width: buttonSize,
                          child: CircularProgressIndicator(
                            color: loadingIndicatorColor,
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
