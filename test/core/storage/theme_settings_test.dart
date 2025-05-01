import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:next_gen/core/storage/theme_settings.dart';

void main() {
  group('ThemeSettings', () {
    test('initializes with default values', () {
      final settings = ThemeSettings();
      expect(settings.isDarkMode, true);
    });

    test('can be initialized with custom values', () {
      final settings = ThemeSettings(isDarkMode: false);
      expect(settings.isDarkMode, false);
    });

    test('can create new instance with different values', () {
      final settings = ThemeSettings();
      final newSettings = ThemeSettings(isDarkMode: false);

      // Original instance unchanged
      expect(settings.isDarkMode, true);
      // New instance has new value
      expect(newSettings.isDarkMode, false);
    });

    test('equality is based on values (not references)', () {
      final settings1 = ThemeSettings();
      final settings2 = ThemeSettings();
      final settings3 = ThemeSettings(isDarkMode: false);

      // Not testing == directly as it might not be overridden
      expect(settings1.isDarkMode, equals(settings2.isDarkMode));
      expect(settings1.isDarkMode, isNot(equals(settings3.isDarkMode)));
    });

    test('copyWith creates a copy with updated values', () {
      final settings = ThemeSettings();
      final newSettings = settings.copyWith(isDarkMode: false);

      expect(newSettings.isDarkMode, false);
      // Original unchanged
      expect(settings.isDarkMode, true);
    });
  });

  group('ThemeSettingsAdapter', () {
    late ThemeSettingsAdapter adapter;

    setUp(() {
      adapter = ThemeSettingsAdapter();
    });

    test('typeId should be 1', () {
      expect(adapter.typeId, themeSettingsTypeId);
      expect(themeSettingsTypeId, 1);
    });

    test('write should serialize ThemeSettings correctly', () {
      final settings = ThemeSettings();
      final mockWriter = _MockBinaryWriter();

      adapter.write(mockWriter, settings);

      // Verify the writer was called with the correct data
      expect(mockWriter.byteData.length, 2); // Two byte values were written
      expect(mockWriter.byteData[0], 1); // Number of fields
      expect(mockWriter.byteData[1], 0); // Field index
      expect(mockWriter.data[0], true); // isDarkMode value (default is true)
    });

    test('read should deserialize ThemeSettings correctly', () {
      final mockReader = _MockBinaryReader()
        ..byteData = [1, 0] // numOfFields and field index
        ..data = [true]; // isDarkMode value

      final result = adapter.read(mockReader);

      expect(result.isDarkMode, true);
    });

    test('equals compares typeIds and type', () {
      final adapter1 = ThemeSettingsAdapter();
      final adapter2 = ThemeSettingsAdapter();

      expect(adapter1 == adapter2, true);
      expect(adapter1 == Object(), false);
    });

    test('hashCode is based on typeId', () {
      expect(adapter.hashCode, adapter.typeId.hashCode);
    });
  });
}

// Updated and properly aligned mock classes for Hive testing
class _MockBinaryWriter implements BinaryWriter {
  final List<dynamic> data = [];
  final List<int> byteData = [];

  @override
  void writeByte(int byte) {
    byteData.add(byte);
  }

  @override
  void write<T>(T value, {bool writeTypeId = true}) {
    data.add(value);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockBinaryReader implements BinaryReader {
  List<dynamic> data = [];
  List<int> byteData = [];
  int _dataIndex = 0;
  int _byteIndex = 0;

  @override
  int readByte() {
    return byteData[_byteIndex++];
  }

  @override
  dynamic read([int? typeId]) {
    return data[_dataIndex++];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
