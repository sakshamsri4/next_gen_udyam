// This file provides imports for Firebase
// It uses the real Firebase packages for all platforms

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/firebase_options.dart';

// Export Firebase packages for use throughout the app
export 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_storage/firebase_storage.dart';
// Export Firebase options
export 'package:next_gen/firebase_options.dart';

// Helper function to initialize Firebase
Future<void> initializeFirebase() async {
  try {
    if (kIsWeb) {
      // For web, the Firebase initialization is done in index.html
      // We just need to initialize the Dart side
      log.i('Initializing Firebase for web');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      // For mobile platforms
      log.i('Initializing Firebase for mobile');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    log.i('Firebase initialized successfully');
  } catch (e) {
    log.e('Error initializing Firebase: $e');
    // Continue with the app even if Firebase fails to initialize
    // This allows the app to work in environments where Firebase
    // is not available
  }
}
