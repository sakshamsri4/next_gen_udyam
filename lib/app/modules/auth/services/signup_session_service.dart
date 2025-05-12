import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/auth/models/signup_session.dart';
import 'package:next_gen/app/modules/auth/models/signup_session_adapter_helper.dart';
import 'package:next_gen/core/di/service_locator.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/hive_manager.dart';

/// A service for handling signup session persistence
class SignupSessionService extends GetxService {
  /// Box name for storing signup sessions
  static const String signupSessionBoxName = 'signup_session_box';

  /// The logger service
  late final LoggerService _logger;

  /// The Hive manager
  late final HiveManager _hiveManager;

  /// Flag to track if adapters have been registered
  bool _adaptersRegistered = false;

  @override
  void onInit() {
    super.onInit();

    // Initialize dependencies
    try {
      _logger = Get.find<LoggerService>();
    } catch (e) {
      // Fallback if logger is not available
      _logger = Get.put(LoggerService(), permanent: true);
    }

    // Get HiveManager from service locator or create a new instance
    try {
      _hiveManager = serviceLocator<HiveManager>();
      _logger.d('Got HiveManager from service locator');
    } catch (e) {
      _logger
          .w('HiveManager not found in service locator, creating new instance');
      _hiveManager = HiveManager();

      // Initialize HiveManager
      _hiveManager.initialize().then((_) {
        _logger.d('HiveManager initialized');
        // Register adapters after initialization
        _ensureAdaptersRegistered();
        // Open the signup session box
        _openSignupSessionBox();
      }).catchError((Object error) {
        _logger.e('Error initializing HiveManager', error);
      });
    }

    // Register adapters during initialization
    _ensureAdaptersRegistered();

    // Try to open the signup session box
    _openSignupSessionBox();
  }

  /// Ensure adapters are registered
  void _ensureAdaptersRegistered() {
    if (!_adaptersRegistered &&
        !SignupSessionAdapterHelper.areAdaptersRegistered) {
      _logger.d('Ensuring SignupSession adapters are registered');
      SignupSessionAdapterHelper.registerAdapters(_logger);
      _adaptersRegistered = true;
    } else {
      _logger.d('SignupSession adapters already registered');
    }
  }

  /// Open the signup session box
  Future<void> _openSignupSessionBox() async {
    try {
      if (!Hive.isBoxOpen(signupSessionBoxName)) {
        _logger.d('Opening SignupSession box');
        await Hive.openBox<SignupSession>(signupSessionBoxName);
        _logger.d('SignupSession box opened successfully');
      } else {
        _logger.d('SignupSession box is already open');
      }
    } catch (e, stackTrace) {
      _logger.e('Error opening SignupSession box', e, stackTrace);
      // Try to ensure Hive is initialized first
      try {
        await _hiveManager.ensureInitialized();
        if (!Hive.isBoxOpen(signupSessionBoxName)) {
          _logger.d('Retrying opening SignupSession box after initialization');
          await Hive.openBox<SignupSession>(signupSessionBoxName);
          _logger.d('SignupSession box opened successfully on retry');
        }
      } catch (e2, stackTrace2) {
        _logger.e('Error opening SignupSession box on retry', e2, stackTrace2);
      }
    }
  }

  /// Save a signup session to Hive
  Future<void> saveSession(SignupSession session) async {
    try {
      _logger.d('Saving signup session for email: ${session.email}');

      // Ensure adapters are registered
      _ensureAdaptersRegistered();

      // Ensure Hive is initialized
      await _hiveManager.ensureInitialized();

      // Ensure the box is open
      await _openSignupSessionBox();

      // Save the session using the HiveManager
      await _hiveManager.putValue<SignupSession>(
        signupSessionBoxName,
        session.email,
        session,
      );

      _logger.d('Signup session saved successfully');
    } catch (e, stackTrace) {
      _logger.e('Error saving signup session', e, stackTrace);
      // Log more detailed error information
      if (e is HiveError) {
        _logger.e('HiveError details: ${e.message}', e, stackTrace);
      }

      // Try direct Hive access as a fallback
      try {
        _logger
            .d('Attempting direct Hive access as fallback for saving session');
        if (Hive.isBoxOpen(signupSessionBoxName)) {
          final box = Hive.box<SignupSession>(signupSessionBoxName);
          await box.put(session.email, session);
          _logger.d('Signup session saved successfully via direct Hive access');
        } else {
          final box = await Hive.openBox<SignupSession>(signupSessionBoxName);
          await box.put(session.email, session);
          _logger.d(
            'Signup session saved successfully via direct Hive access after opening box',
          );
        }
      } catch (e2, stackTrace2) {
        _logger.e('Error in fallback save attempt', e2, stackTrace2);
        rethrow; // Rethrow to let caller handle the error
      }
    }
  }

  /// Get a signup session from Hive
  SignupSession? getSession(String email) {
    try {
      _logger.d('Retrieving signup session for email: $email');

      // Ensure adapters are registered
      _ensureAdaptersRegistered();

      // Check if box is open
      if (!Hive.isBoxOpen(signupSessionBoxName)) {
        _logger.d('Box not open, opening it now');
        // Open box synchronously to avoid async issues
        Hive.openBox<SignupSession>(signupSessionBoxName);
      }

      // Get the session using the HiveManager
      final session = _hiveManager.getValue<SignupSession>(
        signupSessionBoxName,
        email,
      );

      if (session != null) {
        _logger.d('Signup session retrieved successfully');
      } else {
        _logger.d('No signup session found for email: $email');
      }

      return session;
    } catch (e, stackTrace) {
      _logger.e('Error retrieving signup session', e, stackTrace);
      // Log more detailed error information
      if (e is HiveError) {
        _logger.e('HiveError details: ${e.message}', e, stackTrace);
      }

      // Try direct Hive access as a fallback
      try {
        _logger.d(
          'Attempting direct Hive access as fallback for retrieving session',
        );
        if (Hive.isBoxOpen(signupSessionBoxName)) {
          final box = Hive.box<SignupSession>(signupSessionBoxName);
          final session = box.get(email);
          if (session != null) {
            _logger.d(
              'Signup session retrieved successfully via direct Hive access',
            );
          }
          return session;
        }
      } catch (e2) {
        _logger.e('Error in fallback retrieval attempt', e2);
      }

      return null;
    }
  }

  /// Delete a signup session from Hive
  Future<void> deleteSession(String email) async {
    try {
      _logger.d('Deleting signup session for email: $email');

      // Ensure adapters are registered
      _ensureAdaptersRegistered();

      // Ensure Hive is initialized
      await _hiveManager.ensureInitialized();

      // Ensure the box is open
      await _openSignupSessionBox();

      // Delete the session using the HiveManager
      await _hiveManager.deleteValue<SignupSession>(
        signupSessionBoxName,
        email,
      );

      _logger.d('Signup session deleted successfully');
    } catch (e, stackTrace) {
      _logger.e('Error deleting signup session', e, stackTrace);
      // Log more detailed error information
      if (e is HiveError) {
        _logger.e('HiveError details: ${e.message}', e, stackTrace);
      }

      // Try direct Hive access as a fallback
      try {
        _logger.d(
          'Attempting direct Hive access as fallback for deleting session',
        );
        if (Hive.isBoxOpen(signupSessionBoxName)) {
          final box = Hive.box<SignupSession>(signupSessionBoxName);
          await box.delete(email);
          _logger
              .d('Signup session deleted successfully via direct Hive access');
        } else {
          final box = await Hive.openBox<SignupSession>(signupSessionBoxName);
          await box.delete(email);
          _logger.d(
            'Signup session deleted successfully via direct Hive access after opening box',
          );
        }
      } catch (e2, stackTrace2) {
        _logger.e('Error in fallback delete attempt', e2, stackTrace2);
      }
    }
  }

  /// Clear all signup sessions from Hive
  Future<void> clearAllSessions() async {
    try {
      _logger.d('Clearing all signup sessions');

      // Ensure adapters are registered
      _ensureAdaptersRegistered();

      // Ensure Hive is initialized
      await _hiveManager.ensureInitialized();

      // Clear the box using the HiveManager
      await _hiveManager.clearBox<SignupSession>(signupSessionBoxName);

      _logger.d('All signup sessions cleared successfully');
    } catch (e, stackTrace) {
      _logger.e('Error clearing signup sessions', e, stackTrace);
      // Log more detailed error information
      if (e is HiveError) {
        _logger.e('HiveError details: ${e.message}', e, stackTrace);
      }
    }
  }

  /// Update a signup session in Hive
  Future<void> updateSession(SignupSession session) async {
    try {
      _logger.d('Updating signup session for email: ${session.email}');

      // Ensure adapters are registered
      _ensureAdaptersRegistered();

      // Ensure Hive is initialized
      await _hiveManager.ensureInitialized();

      // Update the session using the HiveManager (same as saveSession)
      await _hiveManager.putValue<SignupSession>(
        signupSessionBoxName,
        session.email,
        session,
      );

      _logger.d('Signup session updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Error updating signup session', e, stackTrace);
      // Log more detailed error information
      if (e is HiveError) {
        _logger.e('HiveError details: ${e.message}', e, stackTrace);
      }
    }
  }

  /// Check if a signup session exists for the given email
  bool hasSession(String email) {
    try {
      _logger.d('Checking if signup session exists for email: $email');

      // Ensure adapters are registered
      _ensureAdaptersRegistered();

      // Try to get the session using the HiveManager
      final session = _hiveManager.getValue<SignupSession>(
        signupSessionBoxName,
        email,
      );

      // Check if the session exists
      final exists = session != null;
      _logger.d(
        'Signup session ${exists ? "exists" : "does not exist"} for email: $email',
      );
      return exists;
    } catch (e, stackTrace) {
      _logger.e('Error checking for signup session', e, stackTrace);
      // Log more detailed error information
      if (e is HiveError) {
        _logger.e('HiveError details: ${e.message}', e, stackTrace);
      }
      return false;
    }
  }
}
