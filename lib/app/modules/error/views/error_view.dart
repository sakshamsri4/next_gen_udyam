import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/error/controllers/error_controller.dart';
import 'package:next_gen/app/modules/error/widgets/error_widget.dart';
import 'package:next_gen/app/modules/error/widgets/network_status_widget.dart';

/// A view for displaying error information
class ErrorView extends GetView<ErrorController> {
  /// Creates an ErrorView
  const ErrorView({
    this.title,
    this.message,
    this.errorCode,
    this.onRetry,
    this.canGoBack = true,
    this.showNetworkStatus = true,
    super.key,
  });

  /// The title of the error
  final String? title;

  /// The error message
  final String? message;

  /// Optional error code
  final String? errorCode;

  /// Callback when retry button is pressed
  final VoidCallback? onRetry;

  /// Whether the user can go back from this error
  final bool canGoBack;

  /// Whether to show the network status widget
  final bool showNetworkStatus;

  @override
  Widget build(BuildContext context) {
    // Set error details if provided
    if (title != null || message != null) {
      controller.setErrorDetails(
        title: title ?? 'An error occurred',
        message: message ?? 'Something went wrong. Please try again later.',
        code: errorCode,
        retry: onRetry,
        allowBack: canGoBack,
      );
    }

    return Scaffold(
      appBar: canGoBack
          ? AppBar(
              title: Obx(() => Text(controller.errorTitle.value)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      body: Column(
        children: [
          // Network status indicator
          if (showNetworkStatus)
            const NetworkStatusWidget(
              showOnlyWhenOffline: true,
            ),

          // Error content
          Expanded(
            child: Obx(
              () => CustomErrorWidget(
                title: controller.errorTitle.value,
                message: controller.errorMessage.value,
                errorCode: controller.errorCode.value,
                onRetry: controller.onRetry.value,
                canGoBack: controller.canGoBack.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
