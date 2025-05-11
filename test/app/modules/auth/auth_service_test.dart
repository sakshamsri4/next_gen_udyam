import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';

// Mock classes
class MockLoggerService extends Mock implements LoggerService {}

class MockStorageService extends Mock implements StorageService {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  User? get currentUser => null;

  @override
  Stream<User?> authStateChanges() => Stream.value(null);
}

void main() {
  late MockLoggerService mockLoggerService;
  late MockStorageService mockStorageService;
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthService authService;

  setUp(() {
    // Initialize GetX test mode
    Get.testMode = true;

    // Create mocks
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
      ..put<LoggerService>(mockLoggerService)
      ..put<StorageService>(mockStorageService);

    // Create auth service with mock FirebaseAuth
    authService = AuthService.test(
      firebaseAuth: mockFirebaseAuth,
    );
    Get.put<AuthService>(authService);
  });

  tearDown(Get.reset);

  test('AuthService initialization test', () {
    // This test verifies that we can create an AuthService
    // with our mock FirebaseAuth
    expect(authService, isNotNull);
    expect(Get.find<AuthService>(), equals(authService));
  });
}
