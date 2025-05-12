import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/role_based_navigation_factory.dart';
import 'package:next_gen/core/theme/role_themes.dart';

/// A layout widget that adapts to the user's role
///
/// This widget provides a scaffold with the appropriate navigation components
/// based on the user's role. It handles both bottom navigation and drawer navigation.
class RoleBasedLayout extends StatefulWidget {
  /// Creates a role-based layout
  const RoleBasedLayout({
    required this.title,
    required this.body,
    super.key,
    this.showBackButton = false,
    this.centerTitle = true,
    this.actions,
    this.floatingActionButton,
    this.bottomSheet,
  });

  /// The title to display in the app bar
  final String title;

  /// The body content of the layout
  final Widget body;

  /// Optional actions to display in the app bar
  final List<Widget>? actions;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Optional bottom sheet
  final Widget? bottomSheet;

  /// Whether to show the back button in the app bar
  final bool showBackButton;

  /// Whether to center the title in the app bar
  final bool centerTitle;

  @override
  State<RoleBasedLayout> createState() => _RoleBasedLayoutState();
}

class _RoleBasedLayoutState extends State<RoleBasedLayout> {
  // Scaffold key for drawer access
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Controllers
  late NavigationController _navigationController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    try {
      _navigationController = Get.find<NavigationController>();
    } catch (e) {
      debugPrint('Error initializing controllers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Get the current user role
      final userRole = _navigationController.userRole.value;

      // Determine the role-specific colors
      final primaryColor = _getRolePrimaryColor(userRole);
      final backgroundColor = _getRoleBackgroundColor(userRole, context);

      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: widget.centerTitle,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          leading: _buildLeadingIcon(userRole),
          actions: widget.actions,
        ),
        drawer: RoleBasedNavigationFactory.usesSideNav()
            ? RoleBasedNavigationFactory.getDrawerNav()
            : null,
        bottomNavigationBar: RoleBasedNavigationFactory.usesBottomNav()
            ? RoleBasedNavigationFactory.getBottomNav()
            : null,
        floatingActionButton: widget.floatingActionButton,
        bottomSheet: widget.bottomSheet,
        backgroundColor: backgroundColor,
        body: widget.body,
      );
    });
  }

  /// Build the leading icon for the app bar based on user role
  Widget _buildLeadingIcon(UserType? userRole) {
    // If back button is requested, show it regardless of role
    if (widget.showBackButton) {
      return IconButton(
        icon: const HeroIcon(HeroIcons.arrowLeft),
        onPressed: () => Get.back<void>(),
      );
    }

    // For admin, show menu icon to open drawer
    if (userRole == UserType.admin) {
      return IconButton(
        icon: const HeroIcon(HeroIcons.bars3),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      );
    }

    // For other roles, show menu icon or custom icon
    return IconButton(
      icon: const HeroIcon(HeroIcons.bars3),
      onPressed: () {
        // TODO(developer): Implement role-specific drawer or menu
        _scaffoldKey.currentState?.openDrawer();
      },
    );
  }

  /// Get the primary color based on user role
  Color _getRolePrimaryColor(UserType? userRole) {
    switch (userRole) {
      case UserType.employee:
        return RoleThemes.employeePrimary;
      case UserType.employer:
        return RoleThemes.employerPrimary;
      case UserType.admin:
        return RoleThemes.adminPrimary;
      case null:
        return Colors.blueGrey; // Default color
    }
  }

  /// Get the background color based on user role and theme
  Color _getRoleBackgroundColor(UserType? userRole, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isDarkMode) {
      return Theme.of(context).scaffoldBackgroundColor;
    } else {
      switch (userRole) {
        case UserType.employee:
          return RoleThemes.employeeBackground;
        case UserType.employer:
          return RoleThemes.employerBackground;
        case UserType.admin:
          return RoleThemes.adminBackground;
        case null:
          return const Color(0xFFF9FAFB); // Default light color
      }
    }
  }
}
