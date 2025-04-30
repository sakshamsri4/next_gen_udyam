// This is a consolidated stub implementation for Firebase Web
// It's used to avoid compilation errors when building for web
// while we fix the Firebase Web SDK issues

import 'dart:async';

// Firebase Core stub
class Firebase {
  static Future<FirebaseApp> initializeApp({FirebaseOptions? options}) async {
    return FirebaseApp._();
  }
}

class FirebaseApp {
  FirebaseApp._();
  String get name => 'stub-app';
}

class FirebaseOptions {
  FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.authDomain,
    this.storageBucket,
  });
  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String? authDomain;
  final String? storageBucket;

  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: 'AIzaSyCqgFjXKoh67bjYcsAbdgdMpPF7QCYpNEE',
      appId: '1:91032840429:web:a9e9e9f9f9f9f9f9f9f9f9',
      messagingSenderId: '91032840429',
      projectId: 'next-gen-udyam',
      authDomain: 'next-gen-udyam.firebaseapp.com',
      storageBucket: 'next-gen-udyam.firebasestorage.app',
    );
  }
}

// Firebase Auth stub
class FirebaseAuth {
  FirebaseAuth._();

  // Factory constructor for getting instance
  factory FirebaseAuth.getInstance() => FirebaseAuth._();

  // Static instance for compatibility
  static final FirebaseAuth instance = FirebaseAuth._();

  User? get currentUser => null;

  Stream<User?> authStateChanges() => Stream.value(null);

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw UnsupportedError(
      'Firebase Auth is temporarily disabled for web. '
      'Please use the mobile app.',
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw UnsupportedError(
      'Firebase Auth is temporarily disabled for web. '
      'Please use the mobile app.',
    );
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    throw UnsupportedError(
      'Firebase Auth is temporarily disabled for web. '
      'Please use the mobile app.',
    );
  }

  Future<void> signOut() async {
    // No-op
    return;
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    throw UnsupportedError(
      'Firebase Auth is temporarily disabled for web. '
      'Please use the mobile app.',
    );
  }
}

class User {
  User({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified = false,
  });
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;

  Future<void> sendEmailVerification() async {
    throw UnsupportedError(
      'Firebase Auth is temporarily disabled for web. '
      'Please use the mobile app.',
    );
  }

  Future<void> updateDisplayName(String? displayName) async {
    throw UnsupportedError(
      'Firebase Auth is temporarily disabled for web. '
      'Please use the mobile app.',
    );
  }

  Future<void> updatePhotoURL(String? photoURL) async {
    throw UnsupportedError(
      'Firebase Auth is temporarily disabled for web. '
      'Please use the mobile app.',
    );
  }

  Future<void> reload() async {
    // No-op
  }
}

class UserCredential {
  UserCredential({this.user});
  final User? user;
}

class GoogleAuthProvider {
  static AuthCredential credential({String? accessToken, String? idToken}) {
    return AuthCredential();
  }

  void addScope(String scope) {}
}

class AuthCredential {}

// Firebase Storage stub
class FirebaseStorage {
  FirebaseStorage._();

  // Factory constructor for getting instance
  factory FirebaseStorage.getInstance() => FirebaseStorage._();

  // Static instance for compatibility
  static final FirebaseStorage instance = FirebaseStorage._();

  Reference ref([String? path]) {
    return Reference();
  }
}

class Reference {
  Future<String> getDownloadURL() async {
    throw UnsupportedError(
      'Firebase Storage is temporarily disabled for web. '
      'Please use the mobile app.',
    );
  }

  Future<void> putFile(dynamic file) async {
    throw UnsupportedError(
      'Firebase Storage is temporarily disabled for web. '
      'Please use the mobile app.',
    );
  }

  Reference child(String path) {
    return Reference();
  }
}

// Firebase Auth Web Stub class for compatibility
class FirebaseAuthWebStub {
  factory FirebaseAuthWebStub() => _instance;
  FirebaseAuthWebStub._internal();
  // Singleton pattern
  static final FirebaseAuthWebStub _instance = FirebaseAuthWebStub._internal();

  // Stub methods that throw exceptions
  User? get currentUser => throw UnsupportedError(
        'Firebase Auth is temporarily disabled for web. '
        'Please use the mobile app.',
      );

  bool get isSignedIn => false;

  Stream<User?> authStateChanges() => Stream.value(null);

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    throw UnsupportedError(
      'Firebase Auth is temporarily disabled for web. '
      'Please use the mobile app.',
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    throw UnsupportedError(
      'Firebase Auth is temporarily disabled for web. '
      'Please use the mobile app.',
    );
  }

  Future<void> signOut() async {
    // No-op
    return;
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    throw UnsupportedError(
      'Firebase Auth is temporarily disabled for web. '
      'Please use the mobile app.',
    );
  }
}
