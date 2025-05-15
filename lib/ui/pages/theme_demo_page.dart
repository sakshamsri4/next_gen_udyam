import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/theme/theme_controller.dart';
// Import with a specific alias to avoid ambiguity
import 'package:next_gen/ui/components/theme/theme_extensions.dart'
    as app_theme;

/// A page to demonstrate the different themes available in the app
class ThemeDemoPage extends StatelessWidget {
  /// Constructor
  const ThemeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Demo'),
        actions: [
          // Dark mode toggle
          Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: themeController.toggleTheme,
              tooltip: 'Toggle dark mode',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Role selection
            const Text(
              'Select Role Theme',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Role selection buttons
            Row(
              children: [
                Expanded(
                  child: _RoleButton(
                    label: 'Employee',
                    role: UserType.employee,
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF60A5FA),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _RoleButton(
                    label: 'Employer',
                    role: UserType.employer,
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFF059669)
                        : const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _RoleButton(
                    label: 'Admin',
                    role: UserType.admin,
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Current theme info
            Obx(
              () => _ThemeInfoCard(
                isDarkMode: themeController.isDarkMode,
                role: themeController.currentRole,
              ),
            ),

            const SizedBox(height: 32),

            // Theme components showcase
            const Text(
              'Theme Components',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Buttons',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Get.toNamed<dynamic>(Routes.buttonDemo),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Button Demo'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated Button'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined Button'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text Button'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Cards
            const Text(
              'Cards',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Title',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is a card with some content. Cards are used to group related information.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Form elements
            const Text(
              'Form Elements',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Text Field',
                hintText: 'Enter some text',
              ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Checkbox'),
              value: true,
              onChanged: (_) {},
            ),
            SwitchListTile(
              title: const Text('Switch'),
              value: true,
              onChanged: (_) {},
            ),

            const SizedBox(height: 16),

            // Semantic colors
            const Text(
              'Semantic Colors',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ColorChip(
                  label: 'Primary',
                  color: app_theme.BuildContextExtensions(context).primaryColor,
                ),
                _ColorChip(
                  label: 'Success',
                  color: app_theme.BuildContextExtensions(context).successColor,
                ),
                _ColorChip(
                  label: 'Warning',
                  color: app_theme.BuildContextExtensions(context).warningColor,
                ),
                _ColorChip(
                  label: 'Error',
                  color: app_theme.BuildContextExtensions(context).errorColor,
                ),
                _ColorChip(
                  label: 'Info',
                  color: app_theme.BuildContextExtensions(context).infoColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A button to select a role theme
class _RoleButton extends StatelessWidget {
  /// Constructor
  const _RoleButton({
    required this.label,
    required this.role,
    required this.color,
  });

  /// Button label
  final String label;

  /// User role
  final UserType role;

  /// Button color
  final Color color;

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;

    return Obx(
      () => ElevatedButton(
        onPressed: () => themeController.setUserRole(role),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: themeController.currentRole == role ? 4 : 1,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: themeController.currentRole == role
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// A card displaying the current theme information
class _ThemeInfoCard extends StatelessWidget {
  /// Constructor
  const _ThemeInfoCard({
    required this.isDarkMode,
    required this.role,
  });

  /// Whether dark mode is enabled
  final bool isDarkMode;

  /// Current user role
  final UserType? role;

  @override
  Widget build(BuildContext context) {
    var roleName = 'Default';
    if (role == UserType.employee) {
      roleName = 'Employee';
    } else if (role == UserType.employer) {
      roleName = 'Employer';
    } else if (role == UserType.admin) {
      roleName = 'Admin';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text('Role: $roleName'),
            const SizedBox(height: 8),
            Text('Mode: ${isDarkMode ? 'Dark' : 'Light'}'),
          ],
        ),
      ),
    );
  }
}

/// A chip displaying a color
class _ColorChip extends StatelessWidget {
  /// Constructor
  const _ColorChip({
    required this.label,
    required this.color,
  });

  /// Chip label
  final String label;

  /// Chip color
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
    );
  }
}
