import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

class MockLoggerService extends Mock implements LoggerService {}

class MockStorageService extends Mock implements StorageService {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  User? get currentUser => null;

  @override
  Stream<User?> authStateChanges() => Stream.value(null);
}

void main() {
  late MockAuthService mockAuthService;
  late MockLoggerService mockLoggerService;
  late MockStorageService mockStorageService;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    // Initialize GetX test mode
    Get.testMode = true;

    // Create mocks
    mockAuthService = MockAuthService();
    mockLoggerService = MockLoggerService();
    mockStorageService = MockStorageService();
    mockFirebaseAuth = MockFirebaseAuth();

    // Set up default mock behavior
    when(() => mockLoggerService.d(any<String>())).thenReturn(null);
    when(() => mockLoggerService.i(any<String>())).thenReturn(null);
    when(
      () => mockLoggerService.e(
        any<String>(),
        any<dynamic>(),
        any<StackTrace?>(),
      ),
    ).thenReturn(null);

    // Register mocks with GetX
    Get
      ..put<FirebaseAuth>(mockFirebaseAuth)
      ..put<AuthService>(mockAuthService)
      ..put<LoggerService>(mockLoggerService)
      ..put<StorageService>(mockStorageService);
  });

  tearDown(Get.reset);

  test('Firebase initialization test', () {
    // This test just verifies that we can create a mock FirebaseAuth
    // and register it with GetX without errors
    expect(Get.find<FirebaseAuth>(), equals(mockFirebaseAuth));
  });

  test('AuthController initialization test', () {
    // This test verifies that we can create an AuthController
    // with our mock FirebaseAuth
    try {
      final authController = AuthController();
      expect(authController, isNotNull);
    } catch (e) {
      fail('AuthController initialization failed: $e');
    }
  });
}
