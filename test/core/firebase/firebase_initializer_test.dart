import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/core/firebase/firebase_initializer.dart';

// Mock Firebase classes
class MockFirebaseApp extends Mock implements FirebaseApp {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FirebaseInitializer', () {
    test('should initialize Firebase only once', () async {
      // Create a new instance of FirebaseInitializer
      final initializer = FirebaseInitializer();

      // First initialization should succeed
      final result1 = await initializer.initialize();
      expect(result1.isSuccess, isTrue);

      // Second initialization should return the existing instance
      final result2 = await initializer.initialize();
      expect(result2.isSuccess, isTrue);

      // Both results should have the same app instance
      expect(result1.app, equals(result2.app));
    });

    test('should handle initialization errors gracefully', () async {
      // Create a new instance of FirebaseInitializer with a flag to simulate errors
      final initializer = FirebaseInitializer(simulateErrorForTesting: true);

      // Initialization should fail but not throw
      final result = await initializer.initialize();
      expect(result.isSuccess, isFalse);
      expect(result.error, isNotNull);
    });
  });
}
