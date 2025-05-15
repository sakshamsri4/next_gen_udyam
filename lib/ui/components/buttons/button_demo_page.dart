import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/core/theme/button_theme_helper.dart';
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/ui/components/buttons/next_gen_button.dart';

/// A demo page to showcase all button variants
class ButtonDemoPage extends StatefulWidget {
  /// Creates a button demo page
  const ButtonDemoPage({super.key});

  @override
  State<ButtonDemoPage> createState() => _ButtonDemoPageState();
}

class _ButtonDemoPageState extends State<ButtonDemoPage> {
  final RxBool _isLoading = false.obs;
  final RxBool _isDisabled = false.obs;
  final Rx<UserType> _selectedRole = UserType.employee.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Component Library'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoleSelector(),
            const SizedBox(height: 16),
            _buildStateToggles(),
            const SizedBox(height: 24),
            _buildSectionTitle('Primary Buttons'),
            const SizedBox(height: 8),
            _buildPrimaryButtons(),
            const SizedBox(height: 24),
            _buildSectionTitle('Secondary Buttons'),
            const SizedBox(height: 8),
            _buildSecondaryButtons(),
            const SizedBox(height: 24),
            _buildSectionTitle('Outline Buttons'),
            const SizedBox(height: 8),
            _buildOutlineButtons(),
            const SizedBox(height: 24),
            _buildSectionTitle('Text Buttons'),
            const SizedBox(height: 8),
            _buildTextButtons(),
            const SizedBox(height: 24),
            _buildSectionTitle('Icon Buttons'),
            const SizedBox(height: 8),
            _buildIconButtons(),
            const SizedBox(height: 24),
            _buildSectionTitle('Button Sizes'),
            const SizedBox(height: 8),
            _buildButtonSizes(),
            const SizedBox(height: 24),
            _buildSectionTitle('Full Width Buttons'),
            const SizedBox(height: 8),
            _buildFullWidthButtons(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Role',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Obx(
          () => Row(
            children: [
              _buildRoleButton(
                'Employee',
                UserType.employee,
                RoleThemes.employeePrimary,
              ),
              const SizedBox(width: 8),
              _buildRoleButton(
                'Employer',
                UserType.employer,
                RoleThemes.employerPrimary,
              ),
              const SizedBox(width: 8),
              _buildRoleButton(
                'Admin',
                UserType.admin,
                RoleThemes.adminPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleButton(String label, UserType role, Color color) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          _selectedRole.value = role;
          // Also update the AuthController if it exists
          if (Get.isRegistered<AuthController>()) {
            Get.find<AuthController>().setRole(role);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _selectedRole.value == role ? color : Colors.grey.shade200,
          foregroundColor:
              _selectedRole.value == role ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildStateToggles() {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => CheckboxListTile(
              title: const Text('Loading'),
              value: _isLoading.value,
              onChanged: (value) => _isLoading.value = value ?? false,
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => CheckboxListTile(
              title: const Text('Disabled'),
              value: _isDisabled.value,
              onChanged: (value) => _isDisabled.value = value ?? false,
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildPrimaryButtons() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NextGenButton.primary(
            text: 'Primary Button',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
          ),
          const SizedBox(height: 16),
          NextGenButton.primary(
            text: 'With Leading Icon',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            icon: Icons.add,
          ),
          const SizedBox(height: 16),
          NextGenButton.primary(
            text: 'With Trailing Icon',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            icon: Icons.arrow_forward,
            iconPosition: IconPosition.end,
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButtons() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NextGenButton.secondary(
            text: 'Secondary Button',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
          ),
          const SizedBox(height: 16),
          NextGenButton.secondary(
            text: 'With Leading Icon',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            icon: Icons.star,
          ),
          const SizedBox(height: 16),
          NextGenButton.secondary(
            text: 'With Trailing Icon',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            icon: Icons.arrow_forward,
            iconPosition: IconPosition.end,
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineButtons() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NextGenButton.outline(
            text: 'Outline Button',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
          ),
          const SizedBox(height: 16),
          NextGenButton.outline(
            text: 'With Leading Icon',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            icon: Icons.edit,
          ),
          const SizedBox(height: 16),
          NextGenButton.outline(
            text: 'With Trailing Icon',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            icon: Icons.arrow_forward,
            iconPosition: IconPosition.end,
          ),
        ],
      ),
    );
  }

  Widget _buildTextButtons() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NextGenButton.text(
            text: 'Text Button',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
          ),
          const SizedBox(height: 16),
          NextGenButton.text(
            text: 'With Leading Icon',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            icon: Icons.info,
          ),
          const SizedBox(height: 16),
          NextGenButton.text(
            text: 'With Trailing Icon',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            icon: Icons.arrow_forward,
            iconPosition: IconPosition.end,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButtons() {
    return Obx(
      () => Row(
        children: [
          NextGenButton.icon(
            icon: Icons.add,
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            isCircular: true,
          ),
          const SizedBox(width: 16),
          NextGenButton.icon(
            icon: Icons.edit,
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            variant: ButtonVariant.secondary,
            isCircular: true,
          ),
          const SizedBox(width: 16),
          NextGenButton.icon(
            icon: Icons.delete,
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            variant: ButtonVariant.outline,
            isCircular: true,
          ),
          const SizedBox(width: 16),
          NextGenButton.icon(
            icon: Icons.info,
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            variant: ButtonVariant.text,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSizes() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              NextGenButton.primary(
                text: 'Small',
                onPressed: _isDisabled.value ? null : () {},
                isLoading: _isLoading.value,
                role: _selectedRole.value,
                size: ButtonSize.small,
              ),
              const SizedBox(width: 16),
              NextGenButton.primary(
                text: 'Medium',
                onPressed: _isDisabled.value ? null : () {},
                isLoading: _isLoading.value,
                role: _selectedRole.value,
              ),
              const SizedBox(width: 16),
              NextGenButton.primary(
                text: 'Large',
                onPressed: _isDisabled.value ? null : () {},
                isLoading: _isLoading.value,
                role: _selectedRole.value,
                size: ButtonSize.large,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthButtons() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NextGenButton.primary(
            text: 'Full Width Primary Button',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            isFullWidth: true,
          ),
          const SizedBox(height: 16),
          NextGenButton.secondary(
            text: 'Full Width Secondary Button',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            isFullWidth: true,
          ),
          const SizedBox(height: 16),
          NextGenButton.outline(
            text: 'Full Width Outline Button',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            isFullWidth: true,
          ),
          const SizedBox(height: 16),
          NextGenButton.text(
            text: 'Full Width Text Button',
            onPressed: _isDisabled.value ? null : () {},
            isLoading: _isLoading.value,
            role: _selectedRole.value,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
