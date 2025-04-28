import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:next_gen/core/storage/theme_settings.dart';

/// Service for handling storage operations using Hive
class StorageService {
  /// Function type for initializing storage
  static Future<void> Function() initImpl = _defaultInit;

  /// Function type for getting theme settings
  static ThemeSettings Function() getThemeSettingsImpl =
      _defaultGetThemeSettings;

  /// Function type for saving theme settings
  static Future<void> Function(ThemeSettings) saveThemeSettingsImpl =
      _defaultSaveThemeSettings;

  /// Initialize Hive and register adapters
  static Future<void> init() => initImpl();

  /// Get theme settings from Hive
  static ThemeSettings getThemeSettings() => getThemeSettingsImpl();

  /// Save theme settings to Hive
  static Future<void> saveThemeSettings(ThemeSettings settings) =>
      saveThemeSettingsImpl(settings);

  /// Default implementation for initializing storage
  static Future<void> _defaultInit() async {
    if (!kIsWeb) {
      await Hive.initFlutter();
    } else {
      await Hive.initFlutter('next_gen_hive');
    }

    // Register adapters
    Hive.registerAdapter(ThemeSettingsAdapter());

    // Open boxes
    await Hive.openBox<ThemeSettings>(themeSettingsBoxName);
  }

  /// Default implementation for getting theme settings
  static ThemeSettings _defaultGetThemeSettings() {
    final box = Hive.box<ThemeSettings>(themeSettingsBoxName);
    return box.get('theme', defaultValue: ThemeSettings()) ?? ThemeSettings();
  }

  /// Default implementation for saving theme settings
  static Future<void> _defaultSaveThemeSettings(ThemeSettings settings) async {
    final box = Hive.box<ThemeSettings>(themeSettingsBoxName);
    await box.put('theme', settings);
  }
}
