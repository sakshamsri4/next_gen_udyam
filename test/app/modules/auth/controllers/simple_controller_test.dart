import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';

// A tracking mock auth service
class TrackingMockAuthService implements AuthService {
  String? lastEmail;
  String? lastPassword;
  bool signInCalled = false;
  bool signOutCalled = false;

  @override
  Stream<firebase.User?> get authStateChanges => Stream.value(null);

  @override
  firebase.User? get currentUser => null;

  @override
  bool get isLoggedIn => false;

  @override
  Future<firebase.UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    lastEmail = email;
    lastPassword = password;
    signInCalled = true;
    return MockUserCredential();
  }

  @override
  Future<firebase.UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return MockUserCredential();
  }

  @override
  Future<firebase.UserCredential?> signInWithGoogle() async {
    return MockUserCredential();
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  @override
  Future<void> resetPassword(String email) async {}

  @override
  Future<UserModel?> getUserFromHive() async {
    return null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// TestableAuthController that allows us to inject a mock service
class TestableAuthController extends AuthController {
  TestableAuthController(this.mockAuthService);
  final AuthService mockAuthService;

  @override
  AuthService get authService => mockAuthService;

  @override
  void onInit() {
    // Skip the default initialization to avoid Firebase issues
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestableAuthController controller;
  late TrackingMockAuthService mockAuthService;

  setUp(() {
    mockAuthService = TrackingMockAuthService();
    controller = TestableAuthController(mockAuthService);

    // Setup GetX test environment
    Get.testMode = true;
  });

  tearDown(Get.reset);

  group('Basic Auth Controller Tests', () {
    test('Controller initializes correctly', () {
      expect(controller.emailController, isNotNull);
      expect(controller.passwordController, isNotNull);
      expect(controller.nameController, isNotNull);
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
    });

    test('Sign-in calls AuthService with correct parameters', () async {
      controller.emailController.text = 'test@example.com';
      controller.passwordController.text = 'password123';

      await controller.signInWithEmailAndPassword();

      expect(mockAuthService.signInCalled, isTrue);
      expect(mockAuthService.lastEmail, 'test@example.com');
      expect(mockAuthService.lastPassword, 'password123');
      expect(controller.isLoading.value, isFalse);
    });

    test('Sign-out calls AuthService correctly', () async {
      await controller.signOut();

      expect(mockAuthService.signOutCalled, isTrue);
    });
  });
}

class MockUserCredential implements firebase.UserCredential {
  @override
  firebase.User? get user => null;

  @override
  firebase.AdditionalUserInfo? get additionalUserInfo => null;

  @override
  firebase.AuthCredential? get credential => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
