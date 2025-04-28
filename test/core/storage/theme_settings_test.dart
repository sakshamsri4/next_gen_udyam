import 'package:flutter_test/flutter_test.dart';
import 'package:next_gen/core/storage/theme_settings.dart';

void main() {
  group('ThemeSettings', () {
    test('constructor sets isDarkMode correctly', () {
      // Default value
      final settings1 = ThemeSettings();
      expect(settings1.isDarkMode, isFalse);

      // Custom value
      final settings2 = ThemeSettings(isDarkMode: true);
      expect(settings2.isDarkMode, isTrue);
    });
  });

  group('ThemeSettingsAdapter', () {
    late ThemeSettingsAdapter adapter;

    setUp(() {
      adapter = ThemeSettingsAdapter();
    });

    test('typeId is set correctly', () {
      expect(adapter.typeId, equals(themeSettingsTypeId));
    });

    test('hashCode is based on typeId', () {
      expect(adapter.hashCode, equals(themeSettingsTypeId.hashCode));
    });

    test('operator == compares typeId and runtimeType', () {
      // Same instance
      expect(adapter == adapter, isTrue);

      // Different instance, same typeId and runtimeType
      final adapter2 = ThemeSettingsAdapter();
      expect(adapter == adapter2, isTrue);

      // Different type
      expect(adapter == Object(), isFalse);

      // Different typeId (not possible to test directly since typeId is final)
      // We can test the logic though
      expect(identical(adapter, adapter2), isFalse); // Not identical objects
      expect(
        adapter.runtimeType == adapter2.runtimeType,
        isTrue,
      ); // Same runtime type
      expect(adapter.typeId == adapter2.typeId, isTrue); // Same typeId
    });
  });
}
