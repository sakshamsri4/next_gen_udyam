import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// A utility class for showing custom snackbars with NeoPOP styling
class CustomSnackbar {
  /// Private constructor to prevent instantiation
  CustomSnackbar._();

  /// Show a success snackbar
  static void showSuccess({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      title: title,
      message: message,
      contentType: ContentType.success,
      duration: duration,
    );
  }

  /// Show an error snackbar
  static void showError({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      title: title,
      message: message,
      contentType: ContentType.failure,
      duration: duration,
    );
  }

  /// Show a warning snackbar
  static void showWarning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      title: title,
      message: message,
      contentType: ContentType.warning,
      duration: duration,
    );
  }

  /// Show an info snackbar
  static void showInfo({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      title: title,
      message: message,
      contentType: ContentType.help,
      duration: duration,
    );
  }

  /// Show a network error snackbar
  static void showNetworkError({
    String title = 'No Internet Connection',
    String message = 'Please check your internet connection and try again.',
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onRetry,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: duration,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.failure,
        color: AppTheme.errorColor,
      ),
      action: onRetry != null
          ? SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: onRetry,
            )
          : null,
    );

    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  /// Show a custom snackbar
  static void _showSnackbar({
    required String title,
    required String message,
    required ContentType contentType,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: duration,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
}
