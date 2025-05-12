import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';

part 'theme_settings.g.dart';

/// Hive type ID for ThemeSettings
const themeSettingsTypeId = 1;

/// Hive box name for theme settings
const themeSettingsBoxName = 'theme_settings';

/// Model class for theme settings stored in Hive
@HiveType(typeId: themeSettingsTypeId)
class ThemeSettings extends HiveObject {
  /// Constructor for ThemeSettings
  ThemeSettings({
    this.isDarkMode = true,
    this.useMaterial3 = true,
    this.useHighContrast = false,
    this.userRole,
  });

  /// Whether the app is in dark mode
  @HiveField(0)
  bool isDarkMode;

  /// Whether to use Material 3
  @HiveField(1)
  bool useMaterial3;

  /// Whether to use high contrast
  @HiveField(2)
  bool useHighContrast;

  /// The user role for role-specific theming
  @HiveField(3)
  UserType? userRole;

  /// Creates a copy of this ThemeSettings with specified attributes replaced
  ThemeSettings copyWith({
    bool? isDarkMode,
    bool? useMaterial3,
    bool? useHighContrast,
    UserType? userRole,
  }) {
    return ThemeSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      useHighContrast: useHighContrast ?? this.useHighContrast,
      userRole: userRole ?? this.userRole,
    );
  }

  @override
  String toString() {
    return 'ThemeSettings(isDarkMode: $isDarkMode, '
        'useMaterial3: $useMaterial3, '
        'useHighContrast: $useHighContrast, '
        'userRole: $userRole)';
  }
}
