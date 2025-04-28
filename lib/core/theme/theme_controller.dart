import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

/// Controller for managing app theme
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _isDarkMode = false.obs;
  final _prefs = Rx<SharedPreferences?>(null);

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

  /// Load theme preference from shared preferences
  Future<void> _loadThemePreference() async {
    _prefs.value = await SharedPreferences.getInstance();
    _isDarkMode.value = _prefs.value?.getBool('isDarkMode') ?? false;
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _prefs.value?.setBool('isDarkMode', _isDarkMode.value);
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Set theme to light mode
  void setLightMode() {
    _isDarkMode.value = false;
    _prefs.value?.setBool('isDarkMode', false);
    Get.changeThemeMode(ThemeMode.light);
  }

  /// Set theme to dark mode
  void setDarkMode() {
    _isDarkMode.value = true;
    _prefs.value?.setBool('isDarkMode', true);
    Get.changeThemeMode(ThemeMode.dark);
  }
}
