import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';

/// Helper functions for mocking Firebase auth components in tests
class FirebaseAuthMockHelper {
  /// Sets up a mock Firebase user with common properties
  ///
  /// Returns a Map containing the mock objects for easy access
  static Map<String, dynamic> setupFirebaseAuthMocks({
    String uid = 'test-uid',
    String email = 'test@example.com',
    String displayName = 'Test User',
    String photoURL = 'http://example.com/photo.jpg',
    bool emailVerified = true,
    String phoneNumber = '+1234567890',
    bool setupForSuccess = true,
  }) {
    // Create mock objects
    final mockFirebaseAuth = MockFirebaseAuth();
    final mockGoogleSignIn = MockGoogleSignIn();
    final mockUserBox = MockUserBox();
    final mockLogger = MockLoggerService();
    final mockUser = MockFirebaseUser();
    final mockUserCredential = MockUserCredential();
    final mockGoogleSignInAccount = MockGoogleSignInAccount();
    final mockGoogleSignInAuthentication = MockGoogleSignInAuthentication()

      // Set up auth token values
      ..accessToken = 'mock-access-token'
      ..idToken = 'mock-id-token';

    // Setup mock user properties
    when(mockUser.uid).thenReturn(uid);
    when(mockUser.email).thenReturn(email);
    when(mockUser.displayName).thenReturn(displayName);
    when(mockUser.photoURL).thenReturn(photoURL);
    when(mockUser.emailVerified).thenReturn(emailVerified);
    when(mockUser.phoneNumber).thenReturn(phoneNumber);

    // Setup basic authentication flow for success scenario
    if (setupForSuccess) {
      // Auth state changes stream
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(mockUser));

      // Current user
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUserCredential.user).thenReturn(mockUser);

      // Google sign in
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);

      // Create a dummy credential for testing
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: 'mock-access-token',
        idToken: 'mock-id-token',
      );

      when(mockFirebaseAuth.signInWithCredential(credential))
          .thenAnswer((_) async => mockUserCredential);

      // Hive storage operations
      mockUserBox
        ..mockPut('current_user', null)
        ..mockGet('current_user')
        ..mockDelete('current_user');
    }

    return {
      'firebaseAuth': mockFirebaseAuth,
      'googleSignIn': mockGoogleSignIn,
      'userBox': mockUserBox,
      'logger': mockLogger,
      'user': mockUser,
      'userCredential': mockUserCredential,
      'googleSignInAccount': mockGoogleSignInAccount,
      'googleSignInAuthentication': mockGoogleSignInAuthentication,
    };
  }

  /// Creates an AuthService with mocked dependencies
  ///
  /// Use this to create an AuthService for testing
  static AuthService createMockAuthService({
    MockFirebaseAuth? mockFirebaseAuth,
    MockGoogleSignIn? mockGoogleSignIn,
  }) {
    // If mocks weren't provided, create new ones
    mockFirebaseAuth ??= MockFirebaseAuth();
    mockGoogleSignIn ??= MockGoogleSignIn();

    // Use the test constructor for AuthService
    return AuthService.test(
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
    );
  }

  /// Sets up email/password authentication mocks
  ///
  /// Pass in the mock objects from setupFirebaseAuthMocks
  static void setupEmailPasswordAuth({
    required MockFirebaseAuth mockFirebaseAuth,
    required MockUserCredential mockUserCredential,
    required MockFirebaseUser mockUser,
    required MockUserBox mockUserBox,
    String email = 'test@example.com',
    String password = 'password123',
    bool shouldSucceed = true,
    String? failureCode,
  }) {
    if (shouldSucceed) {
      // Setup success path
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockUser.sendEmailVerification())
          .thenAnswer((_) async => Future<void>.value());
      when(mockUserCredential.user).thenReturn(mockUser);

      // Mock Hive operations
      mockUserBox.mockPut('current_user', null);
    } else if (failureCode != null) {
      // Setup failure path with specific code
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenThrow(firebase.FirebaseAuthException(code: failureCode));

      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenThrow(firebase.FirebaseAuthException(code: failureCode));
    } else {
      // Generic failure
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenThrow(Exception('Authentication failed'));

      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenThrow(Exception('Registration failed'));
    }
  }

  /// Sets up Google sign-in authentication mocks
  static void setupGoogleSignIn({
    required MockFirebaseAuth mockFirebaseAuth,
    required MockGoogleSignIn mockGoogleSignIn,
    required MockGoogleSignInAccount mockGoogleSignInAccount,
    required MockGoogleSignInAuthentication mockGoogleSignInAuthentication,
    required MockUserCredential mockUserCredential,
    required MockUserBox mockUserBox,
    bool shouldSucceed = true,
    bool userCancelled = false,
    String? failureCode,
  }) {
    if (userCancelled) {
      // User cancelled the sign-in
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);
      return;
    }

    if (shouldSucceed) {
      // Setup success path
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);

      // Create a dummy credential for testing
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: 'mock-access-token',
        idToken: 'mock-id-token',
      );

      when(mockFirebaseAuth.signInWithCredential(credential))
          .thenAnswer((_) async => mockUserCredential);

      // Mock Hive operations
      mockUserBox.mockPut('current_user', null);
    } else if (failureCode != null) {
      // Setup failure path with specific code
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);

      // Create a dummy credential for testing
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: 'mock-access-token',
        idToken: 'mock-id-token',
      );

      when(mockFirebaseAuth.signInWithCredential(credential))
          .thenThrow(firebase.FirebaseAuthException(code: failureCode));
    } else {
      // Generic failure
      when(mockGoogleSignIn.signIn())
          .thenThrow(Exception('Google sign-in failed'));
    }
  }

  /// Sets up password reset mocks
  static void setupPasswordReset({
    required MockFirebaseAuth mockFirebaseAuth,
    String email = 'test@example.com',
    bool shouldSucceed = true,
    String? failureCode,
  }) {
    if (shouldSucceed) {
      // Setup success path
      when(
        mockFirebaseAuth.sendPasswordResetEmail(
          email: email,
          actionCodeSettings: anyNamed('actionCodeSettings'),
        ),
      ).thenAnswer((_) async => Future<void>.value());
    } else if (failureCode != null) {
      // Setup failure path with specific code
      when(
        mockFirebaseAuth.sendPasswordResetEmail(
          email: email,
          actionCodeSettings: anyNamed('actionCodeSettings'),
        ),
      ).thenThrow(firebase.FirebaseAuthException(code: failureCode));
    } else {
      // Generic failure
      when(
        mockFirebaseAuth.sendPasswordResetEmail(
          email: email,
          actionCodeSettings: anyNamed('actionCodeSettings'),
        ),
      ).thenThrow(Exception('Password reset failed'));
    }
  }
}

/// Shorthand mock classes for Firebase auth components
class MockFirebaseAuth extends Mock implements firebase.FirebaseAuth {
  @override
  Future<void> sendPasswordResetEmail({
    required String email,
    firebase.ActionCodeSettings? actionCodeSettings,
  }) async {
    return Future<void>.value();
  }
}

class MockGoogleSignIn extends Mock implements GoogleSignIn {
  @override
  Future<GoogleSignInAccount?> signIn() async {
    return null;
  }

  @override
  Future<GoogleSignInAccount?> signOut() async {
    return null;
  }
}

class MockUserBox extends Mock {
  // Using methods to mock operations instead of directly mocking methods
  void mockPut(String key, dynamic value) {
    when(put(key, value)).thenAnswer((_) async => Future<void>.value());
  }

  void mockGet(String key) {
    when(get(key)).thenReturn(null);
  }

  void mockDelete(String key) {
    when(delete(key)).thenAnswer((_) async => Future<void>.value());
  }

  Future<void> put(String key, [dynamic value]) async {
    return Future<void>.value();
  }

  dynamic get(String key) {
    return null;
  }

  Future<void> delete(String key) async {
    return Future<void>.value();
  }
}

class MockLoggerService extends Mock {
  void d(String message, [dynamic error, StackTrace? stackTrace]) {}
  void i(String message, [dynamic error, StackTrace? stackTrace]) {}
  void w(String message, [dynamic error, StackTrace? stackTrace]) {}
  void e(String message, [dynamic error, StackTrace? stackTrace]) {}
}

class MockFirebaseUser extends Mock implements firebase.User {
  @override
  String get uid => 'mock-uid';

  @override
  Future<void> sendEmailVerification([
    firebase.ActionCodeSettings? actionCodeSettings,
  ]) async {
    return Future<void>.value();
  }
}

class MockUserCredential extends Mock implements firebase.UserCredential {
  @override
  firebase.User? get user => MockFirebaseUser();
}

class MockGoogleSignInAuthentication implements GoogleSignInAuthentication {
  @override
  String? accessToken;

  @override
  String? idToken;

  @override
  String? get serverAuthCode => null;

  @override
  String toString() => 'MockGoogleSignInAuthentication';
}

class MockGoogleSignInAccount implements GoogleSignInAccount {
  @override
  Future<GoogleSignInAuthentication> get authentication async {
    return MockGoogleSignInAuthentication();
  }

  @override
  String get displayName => 'Mock User';

  @override
  String get email => 'mock@example.com';

  @override
  String get id => 'mock-id';

  @override
  String? get photoUrl => null;

  @override
  String? get serverAuthCode => null;

  @override
  Future<Map<String, String>> get authHeaders async {
    return {'Authorization': 'Bearer mock-token'};
  }

  @override
  Future<void> clearAuthCache() async {
    return Future<void>.value();
  }

  @override
  String toString() => 'MockGoogleSignInAccount';
}
