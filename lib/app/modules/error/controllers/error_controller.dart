import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/core/services/connectivity_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for error handling and network status
class ErrorController extends GetxController {
  /// Logger instance
  final LoggerService _logger = Get.find<LoggerService>();

  /// Connectivity service instance
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();

  /// Current connectivity status
  ConnectivityStatus get connectivityStatus => _connectivityService.status;

  /// Whether the device is currently connected to the internet
  bool get isConnected => _connectivityService.isConnected;

  /// Stream of connectivity status changes
  Stream<ConnectivityStatus> get connectivityStream =>
      _connectivityService.connectivityStream;

  /// Title for the error page
  final Rx<String> errorTitle = 'An error occurred'.obs;

  /// Message for the error page
  final Rx<String> errorMessage =
      'Something went wrong. Please try again later.'.obs;

  /// Error code for the error page
  final Rx<String?> errorCode = Rxn<String>();

  /// Whether the user can go back from the error page
  final RxBool canGoBack = true.obs;

  /// Callback when retry button is pressed
  final Rx<VoidCallback?> onRetry = Rxn<VoidCallback>();

  @override
  void onInit() {
    super.onInit();
    _logger.i('ErrorController initialized');
  }

  /// Check current connectivity status
  Future<ConnectivityStatus> checkConnectivity() async {
    return _connectivityService.checkConnection();
  }

  /// Set error details
  void setErrorDetails({
    required String title,
    required String message,
    String? code,
    VoidCallback? retry,
    bool allowBack = true,
  }) {
    errorTitle.value = title;
    errorMessage.value = message;
    errorCode.value = code;
    onRetry.value = retry;
    canGoBack.value = allowBack;
  }
}
