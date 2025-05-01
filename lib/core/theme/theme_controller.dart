import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/storage/theme_settings.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// Controller for managing app theme
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _isDarkMode = true.obs;
  final _themeSettings = Rx<ThemeSettings>(ThemeSettings(isDarkMode: true));

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
      final settings = StorageService.getThemeSettings();
      _themeSettings.value = settings;
      _isDarkMode.value = settings.isDarkMode;
      Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      // If there's an error, use the default dark mode
      _isDarkMode.value = true;
      _themeSettings.value = ThemeSettings(isDarkMode: true);
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _themeSettings.value = _themeSettings.value.copyWith(
      isDarkMode: _isDarkMode.value,
    );
    StorageService.saveThemeSettings(_themeSettings.value);
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Set theme to light mode
  void setLightMode() {
    _isDarkMode.value = false;
    _themeSettings.value = _themeSettings.value.copyWith(isDarkMode: false);
    StorageService.saveThemeSettings(_themeSettings.value);
    Get.changeThemeMode(ThemeMode.light);
  }

  /// Set theme to dark mode
  void setDarkMode() {
    _isDarkMode.value = true;
    _themeSettings.value = _themeSettings.value.copyWith(isDarkMode: true);
    StorageService.saveThemeSettings(_themeSettings.value);
    Get.changeThemeMode(ThemeMode.dark);
  }
}
