import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/auth/models/signup_session.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Helper class to register SignupSession and SignupStep adapters
class SignupSessionAdapterHelper {
  /// Type IDs for Hive adapters
  static const int signupSessionTypeId = 3;
  static const int signupStepTypeId = 4;

  /// Flag to track if adapters have been registered
  static bool _adaptersRegistered = false;

  /// Register the SignupSession adapter
  static void registerAdapters(LoggerService logger) {
    // If adapters are already registered, don't register again
    if (_adaptersRegistered) {
      logger.d(
        'SignupSession adapters already registered, skipping registration',
      );
      return;
    }

    try {
      logger.d('Registering SignupSession and SignupStep adapters');

      // Register SignupSession adapter
      if (!Hive.isAdapterRegistered(signupSessionTypeId)) {
        logger.d(
          'Registering SignupSession adapter with typeId $signupSessionTypeId',
        );
        // Use the generated adapter from signup_session.g.dart
        Hive.registerAdapter(SignupSessionAdapter());
      }

      // Register SignupStep adapter
      if (!Hive.isAdapterRegistered(signupStepTypeId)) {
        logger.d(
          'Registering SignupStep adapter with typeId $signupStepTypeId',
        );
        // Use the generated adapter from signup_session.g.dart
        Hive.registerAdapter(SignupStepAdapter());
      }

      // Mark adapters as registered
      _adaptersRegistered = true;

      logger.d('SignupSession and SignupStep adapters registered successfully');
    } catch (e, stackTrace) {
      logger.e('Error registering SignupSession adapters', e, stackTrace);
      if (e is HiveError) {
        logger.e('HiveError details: ${e.message}', e, stackTrace);
      }
    }
  }

  /// Check if adapters are registered
  static bool get areAdaptersRegistered => _adaptersRegistered;
}
