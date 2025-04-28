import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/storage/theme_settings.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// Controller for managing app theme
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _isDarkMode = false.obs;
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
  // ignore: unused_element
  void _loadThemePreference() {
    _themeSettings.value = StorageService.getThemeSettings();
    _isDarkMode.value = _themeSettings.value.isDarkMode;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _themeSettings.value.isDarkMode = _isDarkMode.value;
    StorageService.saveThemeSettings(_themeSettings.value);
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Set theme to light mode
  void setLightMode() {
    _isDarkMode.value = false;
    _themeSettings.value.isDarkMode = false;
    StorageService.saveThemeSettings(_themeSettings.value);
    Get.changeThemeMode(ThemeMode.light);
  }

  /// Set theme to dark mode
  void setDarkMode() {
    _isDarkMode.value = true;
    _themeSettings.value.isDarkMode = true;
    StorageService.saveThemeSettings(_themeSettings.value);
    Get.changeThemeMode(ThemeMode.dark);
  }
}
