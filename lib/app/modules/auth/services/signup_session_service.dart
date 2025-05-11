import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/auth/models/signup_session.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// A service for handling signup session persistence
class SignupSessionService extends GetxService {
  /// Box name for storing signup sessions
  static const String signupSessionBoxName = 'signup_session_box';

  /// The logger service
  final LoggerService _logger = Get.find<LoggerService>();

  /// Save a signup session to Hive
  Future<void> saveSession(SignupSession session) async {
    try {
      _logger.d('Saving signup session for email: ${session.email}');

      // Open the box if it's not already open
      if (!Hive.isBoxOpen(signupSessionBoxName)) {
        await Hive.openBox<SignupSession>(signupSessionBoxName);
      }

      // Get the box
      final box = Hive.box<SignupSession>(signupSessionBoxName);

      // Save the session using the email as the key
      await box.put(session.email, session);

      _logger.d('Signup session saved successfully');
    } catch (e, stackTrace) {
      _logger.e('Error saving signup session', e, stackTrace);
    }
  }

  /// Get a signup session from Hive
  SignupSession? getSession(String email) {
    try {
      _logger.d('Retrieving signup session for email: $email');

      // Check if the box is open
      if (!Hive.isBoxOpen(signupSessionBoxName)) {
        _logger.d('Signup session box is not open');
        return null;
      }

      // Get the box
      final box = Hive.box<SignupSession>(signupSessionBoxName);

      // Get the session
      final session = box.get(email);

      if (session != null) {
        _logger.d('Signup session retrieved successfully');
      } else {
        _logger.d('No signup session found for email: $email');
      }

      return session;
    } catch (e, stackTrace) {
      _logger.e('Error retrieving signup session', e, stackTrace);
      return null;
    }
  }

  /// Delete a signup session from Hive
  Future<void> deleteSession(String email) async {
    try {
      _logger.d('Deleting signup session for email: $email');

      // Check if the box is open
      if (!Hive.isBoxOpen(signupSessionBoxName)) {
        await Hive.openBox<SignupSession>(signupSessionBoxName);
      }

      // Get the box
      final box = Hive.box<SignupSession>(signupSessionBoxName);

      // Delete the session
      await box.delete(email);

      _logger.d('Signup session deleted successfully');
    } catch (e, stackTrace) {
      _logger.e('Error deleting signup session', e, stackTrace);
    }
  }

  /// Clear all signup sessions from Hive
  Future<void> clearAllSessions() async {
    try {
      _logger.d('Clearing all signup sessions');

      // Check if the box is open
      if (!Hive.isBoxOpen(signupSessionBoxName)) {
        await Hive.openBox<SignupSession>(signupSessionBoxName);
      }

      // Get the box
      final box = Hive.box<SignupSession>(signupSessionBoxName);

      // Clear the box
      await box.clear();

      _logger.d('All signup sessions cleared successfully');
    } catch (e, stackTrace) {
      _logger.e('Error clearing signup sessions', e, stackTrace);
    }
  }

  /// Update a signup session in Hive
  Future<void> updateSession(SignupSession session) async {
    try {
      _logger.d('Updating signup session for email: ${session.email}');

      // Check if the box is open
      if (!Hive.isBoxOpen(signupSessionBoxName)) {
        await Hive.openBox<SignupSession>(signupSessionBoxName);
      }

      // Get the box
      final box = Hive.box<SignupSession>(signupSessionBoxName);

      // Update the session
      await box.put(session.email, session);

      _logger.d('Signup session updated successfully');
    } catch (e, stackTrace) {
      _logger.e('Error updating signup session', e, stackTrace);
    }
  }

  /// Check if a signup session exists for the given email
  bool hasSession(String email) {
    try {
      // Check if the box is open
      if (!Hive.isBoxOpen(signupSessionBoxName)) {
        _logger.d('Signup session box is not open');
        return false;
      }

      // Get the box
      final box = Hive.box<SignupSession>(signupSessionBoxName);

      // Check if the session exists
      return box.containsKey(email);
    } catch (e, stackTrace) {
      _logger.e('Error checking for signup session', e, stackTrace);
      return false;
    }
  }
}
