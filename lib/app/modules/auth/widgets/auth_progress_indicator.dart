import 'package:flutter/material.dart';
import 'package:next_gen/core/theme/app_theme.dart';

/// Authentication progress step
enum AuthStep {
  /// Initial signup step
  signup,

  /// Email verification step
  verification,

  /// Role selection step
  roleSelection,

  /// Profile completion step
  profileCompletion,

  /// Dashboard entry step
  dashboard,
}

/// A progress indicator for authentication steps
class AuthProgressIndicator extends StatelessWidget {
  /// Creates an authentication progress indicator
  const AuthProgressIndicator({
    required this.currentStep,
    this.showLabels = true,
    super.key,
  });

  /// The current authentication step
  final AuthStep currentStep;

  /// Whether to show labels for each step
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Define step information
    final steps = [
      const _StepInfo(
        step: AuthStep.signup,
        label: 'Signup',
        icon: Icons.person_add,
      ),
      const _StepInfo(
        step: AuthStep.verification,
        label: 'Verification',
        icon: Icons.verified_user,
      ),
      const _StepInfo(
        step: AuthStep.roleSelection,
        label: 'Role',
        icon: Icons.work,
      ),
      const _StepInfo(
        step: AuthStep.profileCompletion,
        label: 'Profile',
        icon: Icons.person,
      ),
      const _StepInfo(
        step: AuthStep.dashboard,
        label: 'Dashboard',
        icon: Icons.dashboard,
      ),
    ];

    // Find the current step index
    final currentIndex = steps.indexWhere((s) => s.step == currentStep);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(steps.length * 2 - 1, (index) {
            // Even indices are step indicators, odd indices are connectors
            if (index.isEven) {
              final stepIndex = index ~/ 2;
              final step = steps[stepIndex];
              final isCompleted = stepIndex < currentIndex;
              final isCurrent = stepIndex == currentIndex;

              return _buildStepIndicator(
                context,
                step,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                isDarkMode: isDarkMode,
              );
            } else {
              // Connector line
              final leftStepIndex = index ~/ 2;
              final isCompleted = leftStepIndex < currentIndex;

              return _buildConnector(
                context,
                isCompleted: isCompleted,
                isDarkMode: isDarkMode,
              );
            }
          }),
        ),
        if (showLabels) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: steps.map((step) {
              final isCompleted = steps.indexOf(step) < currentIndex;
              final isCurrent = steps.indexOf(step) == currentIndex;

              return _buildStepLabel(
                context,
                step,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  /// Build a step indicator
  Widget _buildStepIndicator(
    BuildContext context,
    _StepInfo step, {
    required bool isCompleted,
    required bool isCurrent,
    required bool isDarkMode,
  }) {
    // No need to use theme here

    // Determine colors based on state
    final Color backgroundColor;
    final Color iconColor;

    if (isCompleted) {
      backgroundColor = AppTheme.primaryColor;
      iconColor = Colors.white;
    } else if (isCurrent) {
      backgroundColor = AppTheme.primaryColor.withAlpha(179); // 0.7 * 255 = 179
      iconColor = Colors.white;
    } else {
      backgroundColor =
          isDarkMode ? AppTheme.darkSurface2 : Colors.grey.shade200;
      iconColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withAlpha(77), // 0.3 * 255 = 77
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Icon(
        isCompleted ? Icons.check : step.icon,
        color: iconColor,
        size: 18,
      ),
    );
  }

  /// Build a connector line between steps
  Widget _buildConnector(
    BuildContext context, {
    required bool isCompleted,
    required bool isDarkMode,
  }) {
    final color = isCompleted
        ? AppTheme.primaryColor
        : isDarkMode
            ? Colors.grey.shade700
            : Colors.grey.shade300;

    return Container(
      width: 24,
      height: 2,
      color: color,
    );
  }

  /// Build a step label
  Widget _buildStepLabel(
    BuildContext context,
    _StepInfo step, {
    required bool isCompleted,
    required bool isCurrent,
  }) {
    final theme = Theme.of(context);

    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: isCompleted || isCurrent
          ? AppTheme.primaryColor
          : theme.colorScheme.onSurface.withAlpha(128), // 0.5 * 255 = 128
      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
    );

    return SizedBox(
      width: 60,
      child: Text(
        step.label,
        style: textStyle,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Information about an authentication step
class _StepInfo {
  /// Creates step information
  const _StepInfo({
    required this.step,
    required this.label,
    required this.icon,
  });

  /// The authentication step
  final AuthStep step;

  /// The label for the step
  final String label;

  /// The icon for the step
  final IconData icon;
}
