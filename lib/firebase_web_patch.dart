// This file provides patches for the Firebase Web SDK
// It's used to fix compilation errors when building for web

import 'package:js/js.dart';

// Export the interop classes and methods
export 'firebase_web_interop.dart';

// Patch for firebase_auth_web
@JS('firebase.auth')
external FirebaseAuthPatch get firebaseAuthPatch;

@JS()
@anonymous
class FirebaseAuthPatch {
  external factory FirebaseAuthPatch();
}

// Patch for firebase_storage_web
@JS('firebase.storage')
external FirebaseStoragePatch get firebaseStoragePatch;

@JS()
@anonymous
class FirebaseStoragePatch {
  external factory FirebaseStoragePatch();
}

// Patch for firebase_core_web
@JS('firebase')
external FirebaseCorePatch get firebaseCorePatch;

@JS()
@anonymous
class FirebaseCorePatch {
  external factory FirebaseCorePatch();
}
