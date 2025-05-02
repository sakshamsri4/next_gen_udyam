import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/error/views/error_view.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Service for handling errors throughout the app
class ErrorService extends GetxService {
  /// Factory constructor to return the singleton instance
  factory ErrorService() => _instance;

  /// Internal constructor
  ErrorService._internal();

  /// Singleton instance
  static final ErrorService _instance = ErrorService._internal();

  /// Logger instance
  final LoggerService _logger = Get.find<LoggerService>();

  /// Initialize the service
  Future<ErrorService> init() async {
    _logger.i('Initializing ErrorService');
    return this;
  }

  /// Handle error and show appropriate UI
  void handleError(
    dynamic error,
    StackTrace? stackTrace, {
    String? friendlyMessage,
    bool showDialog = true,
    bool logError = true,
    VoidCallback? onRetry,
  }) {
    if (logError) {
      _logger.e(
        friendlyMessage ?? 'An error occurred',
        error,
        stackTrace,
      );
    }

    if (showDialog) {
      _showErrorDialog(
        error,
        friendlyMessage: friendlyMessage,
        onRetry: onRetry,
      );
    }
  }

  /// Show error dialog
  void _showErrorDialog(
    dynamic error, {
    String? friendlyMessage,
    VoidCallback? onRetry,
  }) {
    // Prevent multiple dialogs
    if (Get.isDialogOpen ?? false) {
      return;
    }

    final message =
        friendlyMessage ?? 'Something went wrong. Please try again later.';

    Get.dialog<dynamic>(
      AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back<dynamic>();
            },
            child: const Text('Close'),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Get.back<dynamic>();
                onRetry();
              },
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  /// Navigate to error page
  void navigateToErrorPage({
    required String title,
    required String message,
    String? errorCode,
    VoidCallback? onRetry,
    bool canGoBack = true,
  }) {
    Get.to<dynamic>(
      () => ErrorView(
        title: title,
        message: message,
        errorCode: errorCode,
        onRetry: onRetry,
        canGoBack: canGoBack,
      ),
    );
  }

  /// Show a snackbar with error message
  void showErrorSnackbar({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade800,
      colorText: Colors.white,
      margin: const EdgeInsets.all(8),
      duration: duration,
      borderRadius: 8,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
    );
  }

  /// Show a snackbar with success message
  void showSuccessSnackbar({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade800,
      colorText: Colors.white,
      margin: const EdgeInsets.all(8),
      duration: duration,
      borderRadius: 8,
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
      ),
    );
  }

  /// Show a snackbar with info message
  void showInfoSnackbar({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade800,
      colorText: Colors.white,
      margin: const EdgeInsets.all(8),
      duration: duration,
      borderRadius: 8,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
    );
  }
}
