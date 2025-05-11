import 'package:flutter_test/flutter_test.dart';
import 'package:next_gen/core/firebase/firebase_initializer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Firebase Initialization', () {
    setUp(FirebaseInitializer.reset);

    test('FirebaseInitializer should handle multiple initialization attempts',
        () async {
      // Create multiple initializers with mock success for testing
      final initializer1 = FirebaseInitializer(mockSuccessForTesting: true);
      final initializer2 = FirebaseInitializer(mockSuccessForTesting: true);
      final initializer3 = FirebaseInitializer(mockSuccessForTesting: true);

      // Initialize Firebase from multiple places
      final futures = await Future.wait([
        initializer1.initialize(),
        initializer2.initialize(),
        initializer3.initialize(),
      ]);

      // All initializations should succeed
      for (final result in futures) {
        expect(result.isSuccess, isTrue);
      }

      // All should return a Firebase app instance
      for (final result in futures) {
        expect(result.app, isNotNull);
      }
    });

    test('FirebaseInitializer should handle errors gracefully', () async {
      // Reset the initializer for this test specifically
      FirebaseInitializer.reset();

      // Create an initializer that simulates errors
      final initializer = FirebaseInitializer(
        simulateErrorForTesting: true,
        // Also set mockSuccessForTesting to avoid waiting for actual Firebase
        mockSuccessForTesting: true,
      );

      // Initialize Firebase
      final result = await initializer.initialize();

      // Should not throw but return error result
      expect(result.isSuccess, isFalse);
      expect(result.error, isNotNull);
      expect(result.errorDetails, isNotNull);
    });

    test(
        'FirebaseInitializer should return mock app when mockSuccessForTesting is true',
        () async {
      // Create an initializer with mock success
      final initializer = FirebaseInitializer(mockSuccessForTesting: true);

      // Initialize Firebase
      final result = await initializer.initialize();

      // Should return success with mock app
      expect(result.isSuccess, isTrue);
      expect(result.app, isNotNull);
      expect(result.app!.name, equals('mock-app'));
    });
  });
}
