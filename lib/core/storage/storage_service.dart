import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/onboarding/models/onboarding_status.dart'
    as onboarding;
import 'package:next_gen/core/di/service_locator.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/hive_manager.dart';
import 'package:next_gen/core/storage/theme_settings.dart' as theme;

/// Service for handling storage operations using Hive
class StorageService {
  /// Constructor
  StorageService() {
    _logger = serviceLocator<LoggerService>();
    _hiveManager = serviceLocator<HiveManager>();
    _logger.i('StorageService initialized');
  }

  /// Static implementation of init for testing
  static Future<void> Function() initImpl = init;

  /// Static implementation of getThemeSettings for testing
  static theme.ThemeSettings Function() getThemeSettingsImpl = () {
    final service = serviceLocator<StorageService>();
    return service.getThemeSettings();
  };

  /// Static implementation of saveThemeSettings for testing
  static Future<void> Function(theme.ThemeSettings) saveThemeSettingsImpl =
      (theme.ThemeSettings settings) async {
    final service = serviceLocator<StorageService>();
    await service.saveThemeSettings(settings);
  };

  /// Logger instance
  late LoggerService _logger;

  /// Hive manager instance
  late HiveManager _hiveManager;

  /// Test backdoor for dependency injection
  /// This should only be used in tests
  void testSetDependencies(HiveManager hiveManager, LoggerService logger) {
    _hiveManager = hiveManager;
    _logger = logger;
  }

  /// Initialize Hive and register adapters
  /// This is now handled by HiveManager
  static Future<void> init() async {
    // This method is kept for backward compatibility
    // The actual initialization is now handled by HiveManager
    // which is initialized by the service locator
  }

  /// Static method to get theme settings
  static theme.ThemeSettings getThemeSettingsStatic() {
    return getThemeSettingsImpl();
  }

  /// Static method to save theme settings
  static Future<void> saveThemeSettingsStatic(
    theme.ThemeSettings settings,
  ) async {
    await saveThemeSettingsImpl(settings);
  }

  /// Get theme settings from Hive
  theme.ThemeSettings getThemeSettings() {
    _logger.d('Getting theme settings from Hive');
    try {
      final settings = _hiveManager.getValue<theme.ThemeSettings>(
        theme.themeSettingsBoxName,
        'theme',
        defaultValue: theme.ThemeSettings(),
      );
      return settings ?? theme.ThemeSettings();
    } catch (e, stackTrace) {
      _logger.e('Error getting theme settings', e, stackTrace);
      return theme.ThemeSettings();
    }
  }

  /// Save theme settings to Hive
  Future<void> saveThemeSettings(theme.ThemeSettings settings) async {
    _logger.d('Saving theme settings to Hive');
    try {
      await _hiveManager.putValue<theme.ThemeSettings>(
        theme.themeSettingsBoxName,
        'theme',
        settings,
      );
      _logger.d('Theme settings saved successfully');
    } catch (e, stackTrace) {
      _logger.e('Error saving theme settings', e, stackTrace);
      rethrow;
    }
  }

  /// Get user from Hive
  UserModel? getUser() {
    _logger.d('Getting user from Hive');
    try {
      return _hiveManager.getValue<UserModel>(userBoxName, 'current_user');
    } catch (e, stackTrace) {
      _logger.e('Error getting user', e, stackTrace);
      return null;
    }
  }

  /// Save user to Hive
  Future<void> saveUser(UserModel user) async {
    _logger.d('Saving user to Hive: ${user.uid}');
    try {
      await _hiveManager.putValue<UserModel>(userBoxName, 'current_user', user);
      _logger.d('User saved successfully');
    } catch (e, stackTrace) {
      _logger.e('Error saving user', e, stackTrace);
      rethrow;
    }
  }

  /// Delete user from Hive
  Future<void> deleteUser() async {
    _logger.d('Deleting user from Hive');
    try {
      await _hiveManager.deleteValue<UserModel>(userBoxName, 'current_user');
      _logger.d('User deleted successfully');
    } catch (e, stackTrace) {
      _logger.e('Error deleting user', e, stackTrace);
      rethrow;
    }
  }

  /// Get onboarding status from Hive
  onboarding.OnboardingStatus? getOnboardingStatus() {
    _logger.d('Getting onboarding status from Hive');
    try {
      return _hiveManager.getValue<onboarding.OnboardingStatus>(
        onboarding.onboardingStatusBoxName,
        'status',
      );
    } catch (e, stackTrace) {
      _logger.e('Error getting onboarding status', e, stackTrace);
      return null;
    }
  }

  /// Save onboarding status to Hive
  Future<void> saveOnboardingStatus(onboarding.OnboardingStatus status) async {
    _logger.d('Saving onboarding status to Hive');
    try {
      await _hiveManager.putValue<onboarding.OnboardingStatus>(
        onboarding.onboardingStatusBoxName,
        'status',
        status,
      );
      _logger.d('Onboarding status saved successfully');
    } catch (e, stackTrace) {
      _logger.e('Error saving onboarding status', e, stackTrace);
      rethrow;
    }
  }

  /// Clear all data from Hive
  Future<void> clearAllData() async {
    _logger.w('Clearing all data from Hive');
    try {
      await _hiveManager
          .clearBox<theme.ThemeSettings>(theme.themeSettingsBoxName);
      await _hiveManager.clearBox<UserModel>(userBoxName);
      await _hiveManager.clearBox<onboarding.OnboardingStatus>(
        onboarding.onboardingStatusBoxName,
      );
      _logger.d('All data cleared successfully');
    } catch (e, stackTrace) {
      _logger.e('Error clearing all data', e, stackTrace);
      rethrow;
    }
  }
}
