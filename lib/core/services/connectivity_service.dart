import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Service for monitoring network connectivity
class ConnectivityService extends GetxService {
  /// Factory constructor to return the singleton instance
  factory ConnectivityService() => _instance;

  /// Internal constructor
  ConnectivityService._internal();

  /// Singleton instance
  static final ConnectivityService _instance = ConnectivityService._internal();

  /// Logger instance
  final LoggerService _logger = Get.find<LoggerService>();

  /// Connectivity instance
  final Connectivity _connectivity = Connectivity();

  /// Internet connection checker instance
  final InternetConnectionChecker _connectionChecker =
      InternetConnectionChecker.createInstance();

  /// Stream controller for connectivity status
  final _connectivityStreamController =
      StreamController<ConnectivityStatus>.broadcast();

  /// Stream of connectivity status
  Stream<ConnectivityStatus> get connectivityStream =>
      _connectivityStreamController.stream;

  /// Current connectivity status
  final Rx<ConnectivityStatus> _status =
      Rx<ConnectivityStatus>(ConnectivityStatus.unknown);

  /// Get current connectivity status
  ConnectivityStatus get status => _status.value;

  /// Whether the device is currently connected to the internet
  bool get isConnected => _status.value == ConnectivityStatus.online;

  /// Subscription to connectivity changes
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Initialize the service
  Future<ConnectivityService> init() async {
    _logger.i('Initializing ConnectivityService');

    // Check initial connectivity
    await _checkConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    return this;
  }

  /// Check current connectivity status
  Future<void> _checkConnectivity() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(connectivityResults);
    } catch (e, s) {
      _logger.e('Error checking connectivity', e, s);
      _updateStatus(ConnectivityStatus.unknown);
    }
  }

  /// Update connection status based on connectivity result
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    _logger.d('Connectivity changed: $results');

    if (results.isEmpty ||
        results.contains(ConnectivityResult.none) && results.length == 1) {
      _updateStatus(ConnectivityStatus.offline);
      return;
    }

    // If we have WiFi or mobile data, check if we actually have internet
    try {
      final hasInternet = await _connectionChecker.hasConnection;
      _updateStatus(
        hasInternet ? ConnectivityStatus.online : ConnectivityStatus.offline,
      );
    } catch (e, s) {
      _logger.e('Error checking internet connection', e, s);
      _updateStatus(ConnectivityStatus.unknown);
    }
  }

  /// Update connectivity status
  void _updateStatus(ConnectivityStatus status) {
    if (_status.value != status) {
      _logger.i('Connectivity status changed: ${_status.value} -> $status');
      _status.value = status;
      _connectivityStreamController.add(status);
    }
  }

  /// Manually check connectivity
  Future<ConnectivityStatus> checkConnection() async {
    await _checkConnectivity();
    return _status.value;
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityStreamController.close();
  }
}

/// Connectivity status enum
enum ConnectivityStatus {
  /// Connected to the internet
  online,

  /// Not connected to the internet
  offline,

  /// Unknown connectivity status
  unknown,
}
