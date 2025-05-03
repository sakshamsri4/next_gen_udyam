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
    _logger = serviceLocator<LoggerService>();
    _storageService = serviceLocator<StorageService>();
    _logger.i('ThemeController initialized');
  }

  /// Test constructor for dependency injection
  /// This should only be used in tests
  @visibleForTesting
  ThemeController.forTesting(this._storageService, this._logger) {
    _logger.i('ThemeController initialized for testing');
  }
  static ThemeController get to => Get.find();

  /// Logger instance
  late final LoggerService _logger;

  /// Storage service instance
  late final StorageService _storageService;

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
      _logger.d('Loading theme preference from storage');
      final settings = _storageService.getThemeSettings();
      _themeSettings.value = settings;
      _isDarkMode.value = settings.isDarkMode;
      Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
      _logger.d('Theme preference loaded: isDarkMode=${settings.isDarkMode}');
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
    _storageService.saveThemeSettings(_themeSettings.value);
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _logger.d('Theme toggled: isDarkMode=${_isDarkMode.value}');
  }

  /// Set theme to light mode
  void setLightMode() {
    _logger.d('Setting light mode');
    _isDarkMode.value = false;
    _themeSettings.value = _themeSettings.value.copyWith(isDarkMode: false);
    _storageService.saveThemeSettings(_themeSettings.value);
    Get.changeThemeMode(ThemeMode.light);
    _logger.d('Light mode set');
  }

  /// Set theme to dark mode
  void setDarkMode() {
    _logger.d('Setting dark mode');
    _isDarkMode.value = true;
    _themeSettings.value = _themeSettings.value.copyWith(isDarkMode: true);
    _storageService.saveThemeSettings(_themeSettings.value);
    Get.changeThemeMode(ThemeMode.dark);
    _logger.d('Dark mode set');
  }
}
