import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/core/di/service_locator.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/storage/theme_settings.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// Controller for managing app theme
class ThemeController extends GetxController {
  /// Constructor
  ThemeController() {
    try {
      // Try to get LoggerService from GetX first, then from service locator
      try {
        _logger = Get.isRegistered<LoggerService>()
            ? Get.find<LoggerService>()
            : serviceLocator<LoggerService>();
      } catch (e) {
        // If LoggerService is not available, create a new instance
        _logger = LoggerService();
        debugPrint('Created new LoggerService instance in ThemeController: $e');
      }

      // Try to get StorageService, but handle the case when it's not available
      try {
        // Try to get StorageService from GetX first, then from service locator
        _storageService = Get.isRegistered<StorageService>()
            ? Get.find<StorageService>()
            : serviceLocator<StorageService>();
        _logger.i('ThemeController initialized with StorageService');
      } catch (e) {
        _logger.w(
          'StorageService not available during ThemeController initialization: $e',
        );
        // We'll initialize _storageService later when it becomes available
        _storageServiceAvailable = false;
      }
    } catch (e) {
      // If everything fails, create a new LoggerService instance
      _logger = LoggerService();
      debugPrint(
        'LoggerService not available during ThemeController initialization: $e',
      );
      _storageServiceAvailable = false;
    }
  }

  /// Test constructor for dependency injection
  /// This should only be used in tests
  @visibleForTesting
  ThemeController.forTesting(this._storageService, this._logger) {
    _logger.i('ThemeController initialized for testing');
    _storageServiceAvailable = true;
  }

  /// Flag to track if StorageService is available
  bool _storageServiceAvailable = true;

  static ThemeController get to => Get.find();

  /// Logger instance
  late final LoggerService _logger;

  /// Storage service instance
  late StorageService _storageService;

  final _isDarkMode = true.obs;
  final _themeSettings = Rx<ThemeSettings>(ThemeSettings());

  /// Whether the app is in dark mode
  bool get isDarkMode => _isDarkMode.value;

  /// Current theme data
  ThemeData get theme =>
      _isDarkMode.value ? AppTheme.darkTheme : AppTheme.lightTheme;

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }

  /// Load theme preference from Hive
  Future<void> _loadThemePreference() async {
    try {
      // Check if StorageService is available
      if (!_storageServiceAvailable) {
        _logger.w('StorageService not available, using default theme settings');
        _isDarkMode.value = true;
        _themeSettings.value = ThemeSettings();
        Get.changeThemeMode(ThemeMode.dark);

        // Try to get StorageService again from GetX first, then from service locator
        try {
          if (Get.isRegistered<StorageService>()) {
            _storageService = Get.find<StorageService>();
            _storageServiceAvailable = true;
            _logger.i('StorageService found in GetX, will use it now');
          } else if (serviceLocator.isRegistered<StorageService>()) {
            _storageService = serviceLocator<StorageService>();
            _storageServiceAvailable = true;
            _logger
                .i('StorageService found in service locator, will use it now');
          } else {
            _logger.w(
              'StorageService still not available in either GetX or service locator',
            );
          }
        } catch (e) {
          _logger.w('StorageService still not available: $e');
        }
        return;
      }

      _logger.d('Loading theme preference from storage');
      try {
        final settings = _storageService.getThemeSettings();
        _themeSettings.value = settings;
        _isDarkMode.value = settings.isDarkMode;
        Get.changeThemeMode(
          _isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        );
        _logger.d('Theme preference loaded: isDarkMode=${settings.isDarkMode}');
      } catch (storageError) {
        _logger.w('Error getting theme settings, using default: $storageError');
        _isDarkMode.value = true;
        _themeSettings.value = ThemeSettings();
        Get.changeThemeMode(ThemeMode.dark);
      }
    } catch (e, stackTrace) {
      // If there's an error, use the default dark mode
      _logger.e('Error loading theme preference', e, stackTrace);
      _isDarkMode.value = true;
      _themeSettings.value = ThemeSettings();
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    _logger.d('Toggling theme');
    _isDarkMode.value = !_isDarkMode.value;
    _themeSettings.value = _themeSettings.value.copyWith(
      isDarkMode: _isDarkMode.value,
    );

    // Try to save theme settings if StorageService is available
    if (_storageServiceAvailable) {
      try {
        _storageService.saveThemeSettings(_themeSettings.value);
      } catch (e) {
        _logger.w('Failed to save theme settings: $e');
        _storageServiceAvailable = false;

        // Try to get StorageService again
        try {
          _storageService = serviceLocator<StorageService>();
          _storageServiceAvailable = true;
          _logger.i('StorageService now available, saving theme settings');
          _storageService.saveThemeSettings(_themeSettings.value);
        } catch (e2) {
          _logger.w('StorageService still not available: $e2');
        }
      }
    }

    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _logger.d('Theme toggled: isDarkMode=${_isDarkMode.value}');
  }

  /// Set theme to light mode
  void setLightMode() {
    _logger.d('Setting light mode');
    _isDarkMode.value = false;
    _themeSettings.value = _themeSettings.value.copyWith(isDarkMode: false);

    // Try to save theme settings if StorageService is available
    if (_storageServiceAvailable) {
      try {
        _storageService.saveThemeSettings(_themeSettings.value);
      } catch (e) {
        _logger.w('Failed to save light mode settings: $e');
        _storageServiceAvailable = false;
      }
    }

    Get.changeThemeMode(ThemeMode.light);
    _logger.d('Light mode set');
  }

  /// Set theme to dark mode
  void setDarkMode() {
    _logger.d('Setting dark mode');
    _isDarkMode.value = true;
    _themeSettings.value = _themeSettings.value.copyWith(isDarkMode: true);

    // Try to save theme settings if StorageService is available
    if (_storageServiceAvailable) {
      try {
        _storageService.saveThemeSettings(_themeSettings.value);
      } catch (e) {
        _logger.w('Failed to save dark mode settings: $e');
        _storageServiceAvailable = false;
      }
    }

    Get.changeThemeMode(ThemeMode.dark);
    _logger.d('Dark mode set');
  }
}
