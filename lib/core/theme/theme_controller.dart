import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// Controller for managing app theme
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _isDarkMode = true.obs;
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
    _isDarkMode.value = _prefs.value?.getBool('isDarkMode') ?? true;

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
