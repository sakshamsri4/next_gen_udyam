import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:next_gen/app/modules/applications/models/application_model.dart';
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

/// Type IDs for Hive adapters
const int userModelTypeId = 0; // Already defined in the project
const int applicationStatusTypeId = 11; // Type ID for ApplicationStatus enum

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

  /// Initialize Hive
  Future<void> initialize() async {
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

      _logger.i('Hive initialized successfully');
    } catch (e, stackTrace) {
      _logger.e('Error initializing Hive', e, stackTrace);
      rethrow;
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

      _logger.d('All boxes opened successfully');
    } catch (e, stackTrace) {
      _logger.e('Error opening Hive boxes', e, stackTrace);
      rethrow;
    }
  }

  /// Get a box by name
  Box<T> getBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw Exception('Box $boxName is not open');
    }

    return Hive.box<T>(boxName);
  }

  /// Get a value from a box
  T? getValue<T>(String boxName, dynamic key, {T? defaultValue}) {
    final box = getBox<T>(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  /// Put a value in a box
  Future<void> putValue<T>(String boxName, dynamic key, T value) async {
    final box = getBox<T>(boxName);
    await box.put(key, value);
  }

  /// Delete a value from a box
  Future<void> deleteValue<T>(String boxName, dynamic key) async {
    final box = getBox<T>(boxName);
    await box.delete(key);
  }

  /// Clear a box
  Future<void> clearBox<T>(String boxName) async {
    final box = getBox<T>(boxName);
    await box.clear();
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
