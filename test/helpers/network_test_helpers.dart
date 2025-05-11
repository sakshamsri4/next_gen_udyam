import 'dart:async';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:next_gen/core/services/connectivity_service.dart';

/// A mock connectivity service for testing
class MockConnectivityService extends Mock implements ConnectivityService {}

/// A utility class for testing network conditions
class NetworkTestHelpers {
  /// Private constructor to prevent instantiation
  NetworkTestHelpers._();

  /// Set up a mock connectivity service for testing
  ///
  /// [initialStatus] is the initial connectivity status
  /// [statusStream] is a stream of connectivity status changes
  static ConnectivityService setupMockConnectivityService({
    ConnectivityStatus initialStatus = ConnectivityStatus.online,
    Stream<ConnectivityStatus>? statusStream,
  }) {
    final mockService = MockConnectivityService();

    // Set up the status getter
    when(() => mockService.status).thenReturn(initialStatus.obs);

    // Set up the statusStream getter
    final controller = StreamController<ConnectivityStatus>.broadcast();
    when(() => mockService.statusStream)
        .thenAnswer((_) => statusStream ?? controller.stream);

    // Set up the checkConnectivity method
    when(mockService.checkConnectivity).thenAnswer((_) async => initialStatus);

    // Register the mock service with GetX
    if (Get.isRegistered<ConnectivityService>()) {
      Get.replace<ConnectivityService>(mockService);
    } else {
      Get.put<ConnectivityService>(mockService);
    }

    return mockService;
  }

  /// Simulate a network status change
  ///
  /// [service] is the mock connectivity service
  /// [newStatus] is the new connectivity status
  static void simulateNetworkStatusChange(
    MockConnectivityService service,
    ConnectivityStatus newStatus,
  ) {
    when(() => service.status).thenReturn(newStatus.obs);
    when(() => service.checkConnectivity()).thenAnswer((_) async => newStatus);
  }

  /// Simulate a network delay
  ///
  /// [duration] is the duration of the delay
  static Future<void> simulateNetworkDelay({
    Duration duration = const Duration(milliseconds: 500),
  }) async {
    await Future<void>.delayed(duration);
  }

  /// Simulate a network error
  ///
  /// [error] is the error to throw
  static Future<T> simulateNetworkError<T>({
    Object error = const NetworkException('Network error'),
  }) async {
    throw error;
  }
}

/// A custom exception for network errors
class NetworkException implements Exception {
  /// Creates a network exception
  const NetworkException(this.message);

  /// The error message
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}
