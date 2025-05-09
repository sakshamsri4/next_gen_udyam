import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_role.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/widgets/neopop_button.dart';
import 'package:next_gen/widgets/neopop_card.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RoleSelectionView extends GetView<AuthController> {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        AppTheme.deepNavy,
                        AppTheme.navyBlue,
                        AppTheme.darkSurface1,
                      ]
                    : [
                        AppTheme.lightGray,
                        Colors.white,
                        AppTheme.lightGray,
                      ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        NeoPopCard(
                          padding: const EdgeInsets.all(24),
                          borderRadius: 20,
                          elevation: 12,
                          child: Column(
                            children: [
                              Text(
                                'Choose Your Role',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Select how you want to use Next Gen',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Role Selection Cards
                        AnimatedRoleCards(
                          onRoleSelected: controller.selectUserRole,
                          isDarkMode: isDarkMode,
                        ),

                        const SizedBox(height: 32),

                        // Continue Button
                        Obx(
                          () => CustomNeoPopButton.primary(
                            onTap: controller.selectedRole.value != null
                                ? controller.confirmRoleSelection
                                : () {},
                            enabled: controller.selectedRole.value != null,
                            shimmer: true,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              child: controller.isRoleSelectionLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : const Center(
                                      child: Text(
                                        'CONTINUE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedRoleCards extends StatefulWidget {
  const AnimatedRoleCards({
    required this.onRoleSelected,
    required this.isDarkMode,
    super.key,
  });
  final void Function(UserRole?) onRoleSelected;
  final bool isDarkMode;

  @override
  State<AnimatedRoleCards> createState() => _AnimatedRoleCardsState();
}

class _AnimatedRoleCardsState extends State<AnimatedRoleCards>
    with TickerProviderStateMixin {
  late final AnimationController _employerAnimationController;
  late final AnimationController _employeeAnimationController;

  UserRole? _selectedRole;

  @override
  void initState() {
    super.initState();

    _employerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _employeeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _employerAnimationController.dispose();
    _employeeAnimationController.dispose();
    super.dispose();
  }

  void _selectRole(UserRole role) {
    setState(() {
      if (_selectedRole == role) {
        _selectedRole = null;
        _employerAnimationController.reverse();
        _employeeAnimationController.reverse();
      } else {
        _selectedRole = role;
        if (role == UserRole.employer) {
          _employerAnimationController.forward();
          _employeeAnimationController.reverse();
        } else {
          _employeeAnimationController.forward();
          _employerAnimationController.reverse();
        }
      }
    });

    widget.onRoleSelected(_selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Employer Card
        Expanded(
          child: GestureDetector(
            onTap: () => _selectRole(UserRole.employer),
            child: AnimatedBuilder(
              animation: _employerAnimationController,
              builder: (context, child) {
                final scale = 1.0 + (_employerAnimationController.value * 0.05);
                final elevation =
                    8.0 + (_employerAnimationController.value * 8.0);

                return Transform.scale(
                  scale: scale,
                  child: NeoPopCard(
                    padding: const EdgeInsets.all(20),
                    elevation: elevation,
                    color: _selectedRole == UserRole.employer
                        ? (widget.isDarkMode
                            ? AppTheme.electricBlue
                                .withAlpha(51) // 0.2 * 255 = 51
                            : AppTheme.electricBlue
                                .withAlpha(26)) // 0.1 * 255 = 25.5 ≈ 26
                        : null,
                    borderColor: _selectedRole == UserRole.employer
                        ? AppTheme.electricBlue
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: widget.isDarkMode
                                ? AppTheme.darkSurface2
                                : AppTheme.lightGray,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.building,
                              size: 36,
                              color: _selectedRole == UserRole.employer
                                  ? AppTheme.electricBlue
                                  : widget.isDarkMode
                                      ? AppTheme.offWhite
                                      : AppTheme.navyBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          'Employer',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _selectedRole == UserRole.employer
                                ? AppTheme.electricBlue
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Description
                        Text(
                          'I want to post jobs and hire talent',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.isDarkMode
                                ? AppTheme.slateGray
                                : AppTheme.darkGray,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Animation
                        SizedBox(
                          height: 100,
                          child: Lottie.network(
                            'https://assets10.lottiefiles.com/packages/lf20_jtbfg2nb.json',
                            repeat: true,
                            animate: _selectedRole == UserRole.employer,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Employee Card
        Expanded(
          child: GestureDetector(
            onTap: () => _selectRole(UserRole.employee),
            child: AnimatedBuilder(
              animation: _employeeAnimationController,
              builder: (context, child) {
                final scale = 1.0 + (_employeeAnimationController.value * 0.05);
                final elevation =
                    8.0 + (_employeeAnimationController.value * 8.0);

                return Transform.scale(
                  scale: scale,
                  child: NeoPopCard(
                    padding: const EdgeInsets.all(20),
                    elevation: elevation,
                    color: _selectedRole == UserRole.employee
                        ? (widget.isDarkMode
                            ? AppTheme.coralRed.withAlpha(51) // 0.2 * 255 = 51
                            : AppTheme.coralRed
                                .withAlpha(26)) // 0.1 * 255 = 25.5 ≈ 26
                        : null,
                    borderColor: _selectedRole == UserRole.employee
                        ? AppTheme.coralRed
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: widget.isDarkMode
                                ? AppTheme.darkSurface2
                                : AppTheme.lightGray,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.userTie,
                              size: 36,
                              color: _selectedRole == UserRole.employee
                                  ? AppTheme.coralRed
                                  : widget.isDarkMode
                                      ? AppTheme.offWhite
                                      : AppTheme.navyBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          'Job Seeker',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _selectedRole == UserRole.employee
                                ? AppTheme.coralRed
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Description
                        Text(
                          'I want to find jobs and apply for positions',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.isDarkMode
                                ? AppTheme.slateGray
                                : AppTheme.darkGray,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Animation
                        SizedBox(
                          height: 100,
                          child: Lottie.network(
                            'https://assets2.lottiefiles.com/packages/lf20_ddxv3rxu.json',
                            repeat: true,
                            animate: _selectedRole == UserRole.employee,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
