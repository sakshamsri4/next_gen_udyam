import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
import 'package:next_gen/app/modules/auth/models/signup_session.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
// Import UserTypeAdapter explicitly from user_type_adapter.dart to avoid ambiguity
import 'package:next_gen/app/modules/auth/models/user_type_adapter.dart'
    as user_type;
import 'package:next_gen/app/modules/onboarding/models/onboarding_status.dart';
import 'package:next_gen/app/modules/resume/models/resume_model.dart';
import 'package:next_gen/app/modules/search/models/hive_adapters.dart';
import 'package:next_gen/app/modules/search/models/search_history.dart';
import 'package:next_gen/core/di/service_locator.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/theme_settings.dart';

/// Constants for box names
const String userBoxName = 'user_box';
const String searchHistoryBoxName = 'search_history_box';
const String applicationsBoxName = 'applications_box';
const String resumesBoxName = 'resumes_box';
const String signupSessionBoxName = 'signup_session_box';

/// Type IDs for Hive adapters
const int userModelTypeId = 0; // Already defined in the project
const int applicationStatusTypeId = 11; // Type ID for ApplicationStatus enum
const int signupSessionTypeId = 3; // Type ID for SignupSession
const int signupStepTypeId = 4; // Type ID for SignupStep enum

/// Adapter for ApplicationStatus enum
class ApplicationStatusAdapter extends TypeAdapter<ApplicationStatus> {
  @override
  final int typeId = applicationStatusTypeId;

  @override
  ApplicationStatus read(BinaryReader reader) {
    final index = reader.readByte();
    return ApplicationStatus.values[index];
  }

  @override
  void write(BinaryWriter writer, ApplicationStatus obj) {
    writer.writeByte(obj.index);
  }
}

/// Manager class for Hive operations
class HiveManager {
  /// Logger instance
  final LoggerService _logger = serviceLocator<LoggerService>();

  // These maps are kept for reference but not used directly
  // They help document the relationships between types and IDs
  // The actual values are imported from their respective files

  /// Flag to track if Hive has been initialized
  static bool _isInitialized = false;

  /// Initialize Hive
  Future<void> initialize() async {
    // If already initialized, don't initialize again
    if (_isInitialized) {
      _logger.i('Hive already initialized, skipping initialization');
      return;
    }

    _logger.i('Initializing Hive...');

    try {
      // Initialize Hive
      if (kIsWeb) {
        _logger.d('Initializing Hive for web');
        await Hive.initFlutter('next_gen_hive');
      } else {
        _logger.d('Initializing Hive for mobile');
        await Hive.initFlutter();
      }

      // Register adapters
      await _registerAdapters();

      // Open boxes
      await _openBoxes();

      // Verify that critical boxes are open
      _verifyBoxesAreOpen();

      // Mark as initialized
      _isInitialized = true;
      _logger.i('Hive initialized successfully');
    } catch (e, stackTrace) {
      _logger.e('Error initializing Hive', e, stackTrace);
      // Log more detailed error information to help with debugging
      if (e is HiveError) {
        _logger.e('HiveError details: ${e.message}', e, stackTrace);
      }
      rethrow;
    }
  }

  /// Check if Hive is initialized
  bool get isInitialized => _isInitialized;

  /// Verify that critical boxes are open
  void _verifyBoxesAreOpen() {
    final criticalBoxes = [
      userBoxName,
      themeSettingsBoxName,
      onboardingStatusBoxName,
    ];

    for (final boxName in criticalBoxes) {
      if (!Hive.isBoxOpen(boxName)) {
        _logger.e('Critical box $boxName is not open after initialization');
        // Try to open it again
        try {
          // This is synchronous and will throw if it fails
          Hive.openBox<dynamic>(boxName);
          _logger
              .d('Successfully opened critical box $boxName on verification');
        } catch (e) {
          _logger.e('Failed to open critical box $boxName on verification', e);
          // We don't rethrow here to allow the app to continue
        }
      } else {
        _logger.d('Critical box $boxName is open');
      }
    }
  }

  /// Register all adapters
  Future<void> _registerAdapters() async {
    _logger.d('Registering Hive adapters...');

    try {
      // Register ThemeSettings adapter
      if (!Hive.isAdapterRegistered(themeSettingsTypeId)) {
        _logger.d('Registering ThemeSettings adapter');
        Hive.registerAdapter(ThemeSettingsAdapter());
      }

      // Register UserType adapter
      if (!Hive.isAdapterRegistered(20)) {
        // UserType typeId is 20
        _logger.d('Registering UserType adapter');
        Hive.registerAdapter<UserType>(user_type.UserTypeAdapter());
      }

      // Register UserModel adapter
      if (!Hive.isAdapterRegistered(userModelTypeId)) {
        _logger.d('Registering UserModel adapter');
        Hive.registerAdapter(UserModelAdapter());
      }

      // Register OnboardingStatus adapter
      if (!Hive.isAdapterRegistered(onboardingStatusTypeId)) {
        _logger.d('Registering OnboardingStatus adapter');
        Hive.registerAdapter(OnboardingStatusAdapter());
      }

      // Register search module adapters
      _logger.d('Registering search module adapters');
      registerSearchHiveAdapters();

      // Register ApplicationModel adapter
      if (!Hive.isAdapterRegistered(applicationModelTypeId)) {
        _logger.d('Registering ApplicationModel adapter');
        Hive.registerAdapter(ApplicationModelAdapter());
      }

      // Register ApplicationStatus adapter
      if (!Hive.isAdapterRegistered(applicationStatusTypeId)) {
        // ApplicationStatus typeId is 11
        _logger.d('Registering ApplicationStatus adapter');
        Hive.registerAdapter<ApplicationStatus>(ApplicationStatusAdapter());
      }

      // Register ResumeModel adapter
      if (!Hive.isAdapterRegistered(resumeModelTypeId)) {
        _logger.d('Registering ResumeModel adapter');
        Hive.registerAdapter(ResumeModelAdapter());
      }

      // Register SignupSession adapter
      if (!Hive.isAdapterRegistered(signupSessionTypeId)) {
        _logger.d('Registering SignupSession adapter');
        Hive.registerAdapter(SignupSessionAdapter());
      }

      // Register SignupStep adapter
      if (!Hive.isAdapterRegistered(signupStepTypeId)) {
        _logger.d('Registering SignupStep adapter');
        Hive.registerAdapter(SignupStepAdapter());
      }

      _logger.d('All adapters registered successfully');
    } catch (e, stackTrace) {
      _logger.e('Error registering Hive adapters', e, stackTrace);
      // Continue execution even if adapters are already registered
    }
  }

  /// Open all boxes
  Future<void> _openBoxes() async {
    _logger.d('Opening Hive boxes...');

    try {
      // Open ThemeSettings box
      if (!Hive.isBoxOpen(themeSettingsBoxName)) {
        _logger.d('Opening ThemeSettings box');
        await Hive.openBox<ThemeSettings>(themeSettingsBoxName);
      }

      // Open UserModel box
      if (!Hive.isBoxOpen(userBoxName)) {
        _logger.d('Opening UserModel box');
        await Hive.openBox<UserModel>(userBoxName);
      }

      // Open OnboardingStatus box
      if (!Hive.isBoxOpen(onboardingStatusBoxName)) {
        _logger.d('Opening OnboardingStatus box');
        await Hive.openBox<OnboardingStatus>(onboardingStatusBoxName);
      }

      // Open SearchHistory box
      if (!Hive.isBoxOpen(searchHistoryBoxName)) {
        _logger.d('Opening SearchHistory box');
        await Hive.openBox<SearchHistory>(searchHistoryBoxName);
      }

      // Open Applications box
      if (!Hive.isBoxOpen(applicationsBoxName)) {
        _logger.d('Opening Applications box');
        await Hive.openBox<ApplicationModel>(applicationsBoxName);
      }

      // Open Resumes box
      if (!Hive.isBoxOpen(resumesBoxName)) {
        _logger.d('Opening Resumes box');
        await Hive.openBox<ResumeModel>(resumesBoxName);
      }

      // Open SignupSession box
      if (!Hive.isBoxOpen(signupSessionBoxName)) {
        _logger.d('Opening SignupSession box');
        await Hive.openBox<SignupSession>(signupSessionBoxName);
      }

      _logger.d('All boxes opened successfully');
    } catch (e, stackTrace) {
      _logger.e('Error opening Hive boxes', e, stackTrace);
      rethrow;
    }
  }

  /// Get a box by name
  /// If the box is not open, it will be opened automatically
  Future<Box<T>> _openBoxIfNeeded<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      _logger.w('Box $boxName is not open, opening it now');
      try {
        return await Hive.openBox<T>(boxName);
      } catch (e, stackTrace) {
        _logger.e('Error opening box $boxName', e, stackTrace);
        rethrow;
      }
    }
    return Hive.box<T>(boxName);
  }

  /// Get a box by name
  /// This method now tries to open the box if it's not already open
  Box<T> getBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      _logger.w('Box $boxName is not open, attempting to open it first');
      try {
        // Try to open the box synchronously first
        Hive.openBox<T>(boxName);
        _logger.d('Box $boxName opened synchronously');
      } catch (e) {
        _logger.e('Error opening box $boxName synchronously', e);
        // Schedule asynchronous opening for next time
        _openBoxIfNeeded<T>(boxName).then((_) {
          _logger.d('Box $boxName opened asynchronously');
        }).catchError((Object error) {
          _logger.e('Error opening box $boxName asynchronously', error);
        });

        // Throw a more descriptive error to help with debugging
        throw HiveError(
          'Box $boxName is not open and could not be opened synchronously. '
          'Make sure Hive.initFlutter() has been called and the box has been opened '
          'with Hive.openBox() before accessing it.',
        );
      }
    }

    // Only try to access the box if it's actually open now
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    } else {
      // If we still can't open the box, throw a clear error
      throw HiveError(
        'Box $boxName could not be opened. '
        'Please ensure Hive is properly initialized before accessing boxes.',
      );
    }
  }

  /// Get a value from a box
  T? getValue<T>(String boxName, dynamic key, {T? defaultValue}) {
    try {
      // Check if the box is open first
      if (!Hive.isBoxOpen(boxName)) {
        _logger.w(
          'Box $boxName is not open when trying to get value for key: $key',
        );
        // Try to open the box asynchronously for future access
        _openBoxIfNeeded<T>(boxName).then((_) {
          _logger
              .d('Box $boxName opened asynchronously after getValue attempt');
        }).catchError((Object error) {
          _logger.e(
            'Error opening box $boxName asynchronously after getValue attempt',
            error,
          );
        });

        // Return default value since we can't access the box now
        return defaultValue;
      }

      // Box is open, get the value
      final box = Hive.box<T>(boxName);
      return box.get(key, defaultValue: defaultValue);
    } catch (e, stackTrace) {
      _logger.e(
        'Error getting value from box $boxName for key: $key',
        e,
        stackTrace,
      );
      // Return default value if there's an error
      return defaultValue;
    }
  }

  /// Put a value in a box
  Future<void> putValue<T>(String boxName, dynamic key, T value) async {
    try {
      // Check if the box is open first
      if (!Hive.isBoxOpen(boxName)) {
        _logger.w(
          'Box $boxName is not open when trying to put value for key: $key',
        );
        // Open the box first
        await _openBoxIfNeeded<T>(boxName);
        _logger.d('Box $boxName opened for putValue operation');
      }

      // Box should be open now, put the value
      final box = Hive.box<T>(boxName);
      await box.put(key, value);
      _logger.d('Successfully put value in box $boxName for key: $key');
    } catch (e, stackTrace) {
      _logger.e(
        'Error putting value in box $boxName for key: $key',
        e,
        stackTrace,
      );

      // Try one more time with a fresh box opening
      try {
        final box = await _openBoxIfNeeded<T>(boxName);
        await box.put(key, value);
        _logger.d('Successfully put value in box $boxName after retry');
      } catch (e2, stackTrace2) {
        _logger.e(
          'Failed to put value in box $boxName even after retry',
          e2,
          stackTrace2,
        );
        rethrow;
      }
    }
  }

  /// Delete a value from a box
  Future<void> deleteValue<T>(String boxName, dynamic key) async {
    try {
      // Try to get the box
      final box = getBox<T>(boxName);
      await box.delete(key);
    } catch (e, stackTrace) {
      _logger.e('Error deleting value from box $boxName', e, stackTrace);

      // Try to open the box asynchronously and then delete the value
      try {
        final box = await _openBoxIfNeeded<T>(boxName);
        await box.delete(key);
        _logger
            .d('Successfully deleted value from box $boxName after opening it');
      } catch (e2, stackTrace2) {
        _logger.e(
          'Failed to delete value from box $boxName even after trying to open it',
          e2,
          stackTrace2,
        );
        rethrow;
      }
    }
  }

  /// Clear a box
  Future<void> clearBox<T>(String boxName) async {
    try {
      // Try to get the box
      final box = getBox<T>(boxName);
      await box.clear();
    } catch (e, stackTrace) {
      _logger.e('Error clearing box $boxName', e, stackTrace);

      // Try to open the box asynchronously and then clear it
      try {
        final box = await _openBoxIfNeeded<T>(boxName);
        await box.clear();
        _logger.d('Successfully cleared box $boxName after opening it');
      } catch (e2, stackTrace2) {
        _logger.e(
          'Failed to clear box $boxName even after trying to open it',
          e2,
          stackTrace2,
        );
        rethrow;
      }
    }
  }

  /// Close a box
  Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box<dynamic>(boxName).close();
    }
  }

  /// Close all boxes
  Future<void> closeAllBoxes() async {
    await Hive.close();
  }
}
