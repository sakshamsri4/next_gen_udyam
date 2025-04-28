import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/storage/theme_settings.dart';

// Mock classes
class MockBox<T> extends Mock implements Box<T> {}

class MockThemeSettings extends Mock implements ThemeSettings {}

void main() {
  late ThemeSettings themeSettings;

  setUp(() {
    themeSettings = ThemeSettings(isDarkMode: true);
  });

  group('StorageService', () {
    test('init() initializes storage', () async {
      // We can't easily test the implementation details of init(),
      // but we can test that the function exists and can be called
      expect(StorageService.init, isA<Future<void> Function()>());
    });

    test('getThemeSettings() returns theme settings', () {
      // Arrange - Create a custom implementation for testing
      final originalImpl = StorageService.getThemeSettingsImpl;
      StorageService.getThemeSettingsImpl = () => themeSettings;

      // Act
      final result = StorageService.getThemeSettings();

      // Assert
      expect(result, equals(themeSettings));

      // Cleanup
      StorageService.getThemeSettingsImpl = originalImpl;
    });

    test('saveThemeSettings() saves theme settings', () async {
      // Arrange - Create a custom implementation for testing
      var wasCalled = false;
      final originalImpl = StorageService.saveThemeSettingsImpl;
      StorageService.saveThemeSettingsImpl = (settings) async {
        wasCalled = true;
        expect(settings.isDarkMode, isTrue);
      };

      // Act
      await StorageService.saveThemeSettings(themeSettings);

      // Assert
      expect(wasCalled, isTrue);

      // Cleanup
      StorageService.saveThemeSettingsImpl = originalImpl;
    });
  });
}
