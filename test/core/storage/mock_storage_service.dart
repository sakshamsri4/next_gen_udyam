import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:next_gen/core/storage/theme_settings.dart';

/// Mock Box for testing
class MockBox<T> extends Mock implements Box<T> {}

/// Mock implementation for Hive
class MockHive {
  static final Map<String, MockBox<dynamic>> _boxes = {};
  static final themeSettings = ThemeSettings();

  /// Register a mock adapter
  static void registerAdapter<T>(TypeAdapter<T> adapter) {
    // No-op for testing
  }

  /// Initialize Hive for testing
  static Future<void> initFlutter([String? subDir]) async {
    // No-op for testing
  }

  /// Open a mock box
  static Future<Box<T>> openBox<T>(String name) async {
    if (!_boxes.containsKey(name)) {
      final box = MockBox<T>();

      // Set up default behavior for theme settings box
      if (name == themeSettingsBoxName) {
        when(() => box.get('theme', defaultValue: any(named: 'defaultValue')))
            .thenReturn(themeSettings as T);

        when(() => box.put('theme', any())).thenAnswer((invocation) async {
          final settings = invocation.positionalArguments[1] as ThemeSettings;
          themeSettings.isDarkMode = settings.isDarkMode;
        });
      }

      _boxes[name] = box;
    }

    return _boxes[name]! as MockBox<T>;
  }

  /// Get a mock box
  static Box<T> box<T>(String name) {
    if (!_boxes.containsKey(name)) {
      throw Exception('Box $name not found. Call openBox() first.');
    }
    return _boxes[name]! as MockBox<T>;
  }

  /// Reset all mock boxes
  static void resetBoxes() {
    _boxes.clear();
    themeSettings.isDarkMode = false;
  }
}
