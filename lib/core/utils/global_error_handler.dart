import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/error/widgets/custom_snackbar.dart';
import 'package:next_gen/core/services/error_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// A utility class for handling errors globally
class GlobalErrorHandler {
  /// Private constructor to prevent instantiation
  GlobalErrorHandler._();

  /// Initialize the global error handler
  static void init() {
    // Set up Flutter error handling
    FlutterError.onError = _handleFlutterError;

    // Set up Dart error handling
    PlatformDispatcher.instance.onError = _handlePlatformError;

    // Set up Zone error handling
    runZonedGuarded<void>(
      () {
        // This is the body of the zone
        // Any errors thrown here will be caught by the error handler
      },
      _handleZoneError,
    );

    // Log initialization
    Get.find<LoggerService>().i('GlobalErrorHandler initialized');
  }

  /// Handle Flutter errors
  static void _handleFlutterError(FlutterErrorDetails details) {
    // Log the error
    Get.find<LoggerService>().e(
      'Flutter Error: ${details.exception}',
      details.exception,
      details.stack,
    );

    // Handle the error
    _handleError(
      details.exception,
      details.stack,
      'Flutter Error',
    );
  }

  /// Handle platform errors
  static bool _handlePlatformError(Object error, StackTrace stack) {
    // Log the error
    Get.find<LoggerService>().e('Platform Error', error, stack);

    // Handle the error
    _handleError(error, stack, 'Platform Error');

    // Return true to indicate the error was handled
    return true;
  }

  /// Handle zone errors
  static void _handleZoneError(Object error, StackTrace stack) {
    // Log the error
    Get.find<LoggerService>().e('Zone Error', error, stack);

    // Handle the error
    _handleError(error, stack, 'Zone Error');
  }

  /// Handle errors
  static void _handleError(
    Object error,
    StackTrace? stack,
    String source, {
    bool showDialog = false,
  }) {
    try {
      // Get the error service
      final errorService = Get.find<ErrorService>();

      // Create a user-friendly message
      final message = _getUserFriendlyMessage(error);

      // Handle the error
      errorService.handleError(
        error,
        stack,
        friendlyMessage: message,
        showDialog: showDialog,
      );

      // Show a snackbar if not in debug mode
      if (!kDebugMode) {
        CustomSnackbar.showError(
          title: 'Error',
          message: message,
        );
      }
    } catch (e, s) {
      // If error handling fails, log it
      Get.find<LoggerService>().e('Error handling error', e, s);
    }
  }

  /// Get a user-friendly error message
  static String _getUserFriendlyMessage(Object error) {
    if (error is TimeoutException) {
      return 'The operation timed out. Please try again later.';
    } else if (error is FormatException) {
      return 'Invalid format. Please check your input.';
    } else if (error.toString().contains('SocketException') ||
        error.toString().contains('Connection refused')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.toString().contains('permission')) {
      return 'Permission denied. Please check your app permissions.';
    } else {
      return 'Something went wrong. Please try again later.';
    }
  }
}
