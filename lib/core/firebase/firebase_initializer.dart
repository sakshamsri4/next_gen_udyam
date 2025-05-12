import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:next_gen/firebase_options.dart';

/// Mock Firebase App for testing
@immutable
class MockFirebaseApp implements FirebaseApp {
  /// Factory constructor to return the singleton instance
  factory MockFirebaseApp() => _instance;

  /// Private constructor for singleton pattern
  const MockFirebaseApp._internal();

  /// Singleton instance to ensure we always return the same instance
  static const MockFirebaseApp _instance = MockFirebaseApp._internal();

  @override
  String get name => 'mock-app';

  @override
  FirebaseOptions get options => const FirebaseOptions(
        apiKey: 'mock-api-key',
        appId: 'mock-app-id',
        messagingSenderId: 'mock-sender-id',
        projectId: 'mock-project-id',
      );

  @override
  bool get isAutomaticDataCollectionEnabled => false;

  @override
  Future<void> delete() async {}

  @override
  Future<void> setAutomaticDataCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setAutomaticResourceManagementEnabled(bool enabled) async {}

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MockFirebaseApp && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

/// Result of Firebase initialization
class FirebaseInitResult {
  /// Constructor
  FirebaseInitResult({
    required this.isSuccess,
    this.app,
    this.error,
    this.errorDetails,
  });

  /// Create a success result
  factory FirebaseInitResult.success(FirebaseApp app) {
    return FirebaseInitResult(
      isSuccess: true,
      app: app,
    );
  }

  /// Create an error result
  factory FirebaseInitResult.error(Object error, [String? details]) {
    return FirebaseInitResult(
      isSuccess: false,
      error: error,
      errorDetails: details,
    );
  }

  /// Whether initialization was successful
  final bool isSuccess;

  /// The Firebase app instance (if successful)
  final FirebaseApp? app;

  /// Error that occurred during initialization (if any)
  final Object? error;

  /// Additional error details (if any)
  final String? errorDetails;
}

/// Class responsible for initializing Firebase safely
class FirebaseInitializer {
  /// Constructor
  FirebaseInitializer({
    this.simulateErrorForTesting = false,
    this.mockSuccessForTesting = false,
  });

  /// Flag to simulate errors for testing
  final bool simulateErrorForTesting;

  /// Flag to mock success for testing
  final bool mockSuccessForTesting;

  /// Static instance of the initialized Firebase app
  static FirebaseApp? _firebaseApp;

  /// Whether Firebase has been initialized
  static bool _isInitialized = false;

  /// Lock to prevent concurrent initialization
  static Completer<FirebaseInitResult>? _initializationCompleter;

  /// Initialize Firebase safely with timeout
  ///
  /// This method ensures Firebase is only initialized once, even if called
  /// multiple times. It handles errors gracefully and returns a result object
  /// with information about the initialization.
  Future<FirebaseInitResult> initialize({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    // Simulate error for testing if flag is set (highest priority)
    if (simulateErrorForTesting) {
      debugPrint('Simulating error for testing purposes');
      final result = FirebaseInitResult.error(
        Exception('Simulated error for testing'),
        'This is a simulated error for testing purposes',
      );
      return result;
    }

    // For testing purposes, we can mock success
    if (mockSuccessForTesting) {
      debugPrint('Mocking successful Firebase initialization for testing');
      return FirebaseInitResult.success(
        MockFirebaseApp(),
      );
    }

    // If Firebase is already initialized, return the existing app immediately
    if (_isInitialized && _firebaseApp != null) {
      debugPrint('Firebase already initialized, returning existing instance');
      return FirebaseInitResult.success(_firebaseApp!);
    }

    // Check if Firebase is already initialized by checking apps list
    // This is a quick check that doesn't depend on our static variables
    if (Firebase.apps.isNotEmpty) {
      debugPrint('Firebase apps already exist, using existing instance');
      _firebaseApp = Firebase.app();
      _isInitialized = true;
      final result = FirebaseInitResult.success(_firebaseApp!);
      return result;
    }

    // No need for a local completer anymore

    // Create a new static completer if one doesn't exist
    _initializationCompleter ??= Completer<FirebaseInitResult>();

    // If initialization is already in progress, wait for it to complete with timeout
    if (_initializationCompleter != null &&
        !_initializationCompleter!.isCompleted) {
      debugPrint(
        'Firebase initialization in progress, waiting for completion with timeout',
      );

      // Set up a timeout to prevent waiting forever
      return _initializationCompleter!.future.timeout(
        timeout,
        onTimeout: () {
          debugPrint(
            'Firebase initialization timed out, creating new instance',
          );
          // Reset the static state
          _initializationCompleter = null;
          _isInitialized = false;
          _firebaseApp = null;

          // Try to initialize again
          return _initializeFirebase();
        },
      );
    }

    // If we get here, we need to initialize Firebase
    return _initializeFirebase();
  }

  /// Internal method to actually initialize Firebase
  Future<FirebaseInitResult> _initializeFirebase() async {
    // Create a new completer if the previous one was completed or null
    _initializationCompleter = Completer<FirebaseInitResult>();

    try {
      // Double-check if Firebase is already initialized
      if (Firebase.apps.isNotEmpty) {
        debugPrint(
          'Firebase apps already exist (double-check), using existing instance',
        );
        _firebaseApp = Firebase.app();
        _isInitialized = true;
        final result = FirebaseInitResult.success(_firebaseApp!);
        if (!_initializationCompleter!.isCompleted) {
          _initializationCompleter!.complete(result);
        }
        return result;
      }

      // Initialize Firebase
      debugPrint('Initializing Firebase for the first time');
      _firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;

      final result = FirebaseInitResult.success(_firebaseApp!);
      if (!_initializationCompleter!.isCompleted) {
        _initializationCompleter!.complete(result);
      }
      return result;
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');

      // If the error is a duplicate app error, try to get the existing app
      if (e is FirebaseException && e.code == 'duplicate-app') {
        debugPrint('Duplicate app error, trying to get existing app');
        try {
          _firebaseApp = Firebase.app();
          _isInitialized = true;
          final result = FirebaseInitResult.success(_firebaseApp!);
          if (!_initializationCompleter!.isCompleted) {
            _initializationCompleter!.complete(result);
          }
          return result;
        } catch (innerError) {
          debugPrint('Error getting existing Firebase app: $innerError');
          final result = FirebaseInitResult.error(
            innerError,
            'Failed to get existing Firebase app after duplicate-app error',
          );
          if (!_initializationCompleter!.isCompleted) {
            _initializationCompleter!.complete(result);
          }
          return result;
        }
      }

      // Handle other errors
      final result = FirebaseInitResult.error(e);
      if (!_initializationCompleter!.isCompleted) {
        _initializationCompleter!.complete(result);
      }
      return result;
    }
  }

  /// Reset the initializer (for testing purposes only)
  @visibleForTesting
  static void reset() {
    _isInitialized = false;
    _firebaseApp = null;
    _initializationCompleter = null;
  }
}
