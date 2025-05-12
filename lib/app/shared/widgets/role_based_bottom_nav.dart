import 'package:flutter/material.dart';
import 'package:next_gen/app/shared/widgets/unified_bottom_nav.dart';

/// A bottom navigation bar that adapts to the user's role
///
/// This widget uses a StatefulWidget approach to properly manage state and avoid
/// reactive state management issues. It listens to the NavigationController's
/// selectedIndex and userRole values and rebuilds only when those values change.
///
/// @deprecated Use [UnifiedBottomNav] instead. This widget is maintained for
/// backward compatibility but will be removed in a future release.
@Deprecated('Use UnifiedBottomNav instead')
class RoleBasedBottomNav extends StatefulWidget {
  /// Creates a role-based bottom navigation bar
  @Deprecated('Use UnifiedBottomNav instead')
  const RoleBasedBottomNav({super.key});

  @override
  State<RoleBasedBottomNav> createState() => _RoleBasedBottomNavState();
}

// This class is marked as deprecated and simply forwards to UnifiedBottomNav
// to maintain backward compatibility
class _RoleBasedBottomNavState extends State<RoleBasedBottomNav> {
  @override
  Widget build(BuildContext context) {
    // Simply forward to UnifiedBottomNav
    return const UnifiedBottomNav();
  }
}
