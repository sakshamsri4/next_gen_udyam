import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/core/di/service_locator.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/storage/theme_settings.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/role_themes.dart';

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
  final _currentRole = Rx<UserType?>(null);

  /// Whether the app is in dark mode
  bool get isDarkMode => _isDarkMode.value;

  /// Current user role
  UserType? get currentRole => _currentRole.value;

  /// Current theme data
  ThemeData get theme {
    // If a role is set, use role-specific theme
    if (_currentRole.value != null) {
      return RoleThemes.getThemeForRole(_currentRole.value, _isDarkMode.value);
    }
    // Otherwise use default theme
    return _isDarkMode.value ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

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
        _currentRole.value = settings.userRole;

        // Apply theme based on role and dark mode
        _applyTheme();

        _logger.d(
          'Theme preference loaded: isDarkMode=${settings.isDarkMode}, userRole=${settings.userRole}',
        );
      } catch (storageError) {
        _logger.w('Error getting theme settings, using default: $storageError');
        _isDarkMode.value = true;
        _themeSettings.value = ThemeSettings();

        // Try to get user role from auth controller if available
        _tryLoadUserRoleFromAuth();

        // Apply theme
        _applyTheme();
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

    _applyTheme();
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

    _applyTheme();
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

    _applyTheme();
    _logger.d('Dark mode set');
  }

  /// Set the user role for theming
  void setUserRole(UserType? role) {
    _logger.d('Setting user role: $role');
    if (_currentRole.value == role) {
      _logger.d('Role is already set to $role, skipping');
      return;
    }

    _currentRole.value = role;
    _themeSettings.value = _themeSettings.value.copyWith(userRole: role);

    // Try to save theme settings if StorageService is available
    if (_storageServiceAvailable) {
      try {
        _storageService.saveThemeSettings(_themeSettings.value);
      } catch (e) {
        _logger.w('Failed to save role settings: $e');
        _storageServiceAvailable = false;
      }
    }

    _applyTheme();
    _logger.d('User role set to $role');
  }

  /// Apply the current theme based on role and dark mode
  void _applyTheme() {
    final themeData = theme;
    Get
      ..changeTheme(themeData)
      ..changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _logger.d(
      'Theme applied: isDarkMode=${_isDarkMode.value}, role=${_currentRole.value}',
    );
  }

  /// Try to load user role from auth service
  void _tryLoadUserRoleFromAuth() {
    try {
      if (Get.isRegistered<AuthController>() &&
          Get.isRegistered<AuthService>()) {
        final authService = Get.find<AuthService>();

        // Use a future to get the user model
        authService.getUserFromFirebase().then((UserModel? userModel) {
          if (userModel != null && userModel.userType != null) {
            _currentRole.value = userModel.userType;
            _logger.d(
              'Loaded user role from auth service: ${_currentRole.value}',
            );

            // Apply theme after role is loaded
            _applyTheme();
          }
        }).catchError((Object error) {
          _logger.w('Error getting user model from Firebase: $error');
        });
      }
    } catch (e) {
      _logger.w('Failed to load user role from auth service: $e');
    }
  }
}
