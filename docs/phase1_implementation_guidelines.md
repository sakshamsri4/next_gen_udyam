# Phase 1 Implementation Guidelines: Foundation

This document provides detailed implementation guidelines for Phase 1 of the Next Gen Udyam UI/UX roadmap. It outlines the technical approach, component specifications, and implementation strategies for creating role-specific user experiences.

## Overview

Phase 1 focuses on establishing the foundation for role-based user interfaces, including:
1. Role-specific navigation systems with distinct visual styling
2. Basic home screens for each role with appropriate content and color schemes
3. Enhanced role selection flow with clear visual differentiation
4. Refactored route management for role-based navigation

## 1. Role-Specific Navigation Systems

### Technical Approach

#### Navigation Components
- Create a `RoleBasedBottomNav` widget that adapts based on user role
- Implement a `RoleBasedDrawer` for additional navigation options
- Design role-specific app bars with appropriate actions and styling

#### Theme Management
- Implement a `ThemeController` to manage role-based themes
- Create role-specific theme data objects with appropriate color schemes
- Use theme extensions for custom properties like role-specific shadows or animations

#### Navigation Structure

**Employee Navigation (Blue Theme)**
```dart
final employeeNavItems = [
  NavItem(icon: Icons.home, label: 'Home', route: Routes.employeeHome),
  NavItem(icon: Icons.search, label: 'Search', route: Routes.jobSearch),
  NavItem(icon: Icons.bookmark, label: 'Saved', route: Routes.savedJobs),
  NavItem(icon: Icons.description, label: 'Applications', route: Routes.applications),
  NavItem(icon: Icons.person, label: 'Profile', route: Routes.employeeProfile),
];
```

**Employer Navigation (Green Theme)**
```dart
final employerNavItems = [
  NavItem(icon: Icons.dashboard, label: 'Dashboard', route: Routes.employerDashboard),
  NavItem(icon: Icons.work, label: 'Jobs', route: Routes.jobManagement),
  NavItem(icon: Icons.people, label: 'Applicants', route: Routes.applicants),
  NavItem(icon: Icons.business, label: 'Company', route: Routes.companyProfile),
  NavItem(icon: Icons.settings, label: 'Settings', route: Routes.settings),
];
```

**Admin Navigation (Indigo Theme)**
```dart
final adminNavItems = [
  NavItem(icon: Icons.dashboard, label: 'Dashboard', route: Routes.adminDashboard),
  NavItem(icon: Icons.people, label: 'Users', route: Routes.userManagement),
  NavItem(icon: Icons.content_paste, label: 'Content', route: Routes.contentModeration),
  NavItem(icon: Icons.settings, label: 'Settings', route: Routes.systemSettings),
  NavItem(icon: Icons.analytics, label: 'Analytics', route: Routes.systemAnalytics),
];
```

### Implementation Steps

1. **Create Theme Service**
   - Implement `ThemeService` with methods to get role-specific themes
   - Create theme data objects for each role with appropriate color schemes
   - Add theme switching functionality based on role changes

2. **Build Navigation Components**
   - Create `RoleBasedBottomNav` widget that adapts to user role
   - Implement `RoleBasedDrawer` for additional navigation options
   - Design role-specific app bars with appropriate actions

3. **Implement Navigation Logic**
   - Create navigation controller to manage active routes
   - Implement role-based navigation state persistence
   - Add animations for navigation transitions

## 2. Basic Home Screens for Each Role

### Technical Approach

#### Screen Architecture
- Create role-specific home screen controllers
- Implement responsive layouts for each home screen
- Design reusable card components for different content types

#### Content Strategy

**Employee Home Screen**
- Job recommendations section (personalized algorithm)
- Recently viewed jobs (local storage + cloud sync)
- Application status updates (real-time notifications)
- Quick search bar (with recent search history)

**Employer Home Screen**
- Key metrics dashboard (job views, applications, conversion rates)
- Recent activity feed (applicant actions, system notifications)
- Quick actions (post job, review applications, edit profile)
- Upcoming interviews and tasks (calendar integration)

**Admin Home Screen**
- System health metrics (user counts, content metrics, error rates)
- User growth statistics (charts and trends)
- Content moderation queue (flagged items, pending approvals)
- Recent activity log (system events, user actions)

### Implementation Steps

1. **Create Home Screen Controllers**
   - Implement role-specific controllers with appropriate data fetching
   - Add reactive state management for UI updates
   - Implement error handling and loading states

2. **Design UI Components**
   - Create reusable card components for different content types
   - Implement skeleton loaders for content-heavy sections
   - Design empty states for sections with no data

3. **Implement Data Services**
   - Create services for fetching role-specific data
   - Implement caching strategies for improved performance
   - Add refresh mechanisms for data updates

## 3. Role Selection Flow

### Technical Approach

#### Selection Experience
- Create an intuitive role selection screen with visual representations
- Use role-specific colors and icons to differentiate options
- Provide brief descriptions of each role's capabilities

#### User Flow
- Present role selection after initial sign-up
- Allow role switching from profile settings
- Implement smooth transitions between roles
- Persist role selection in user profile

### Implementation Steps

1. **Design Role Selection UI**
   - Create visually distinct role option cards
   - Implement selection animations and feedback
   - Add role descriptions and capability highlights

2. **Implement Selection Logic**
   - Create `RoleSelectionController` to manage selection state
   - Implement role persistence in user profile
   - Add validation for role eligibility (if applicable)

3. **Add Role Switching**
   - Implement role switching in profile settings
   - Create confirmation dialogs for role changes
   - Handle data persistence across role switches

## 4. Route Management for Role-Based Navigation

### Technical Approach

#### Routing Architecture
- Implement middleware for route access control
- Create role-specific route groups
- Handle unauthorized access attempts gracefully

#### Navigation State
- Maintain navigation state when switching between screens
- Implement deep linking support for role-appropriate screens
- Add analytics tracking for navigation events

### Implementation Steps

1. **Create Route Guard**
   - Implement `RouteGuard` middleware to check role permissions
   - Create role-based route maps in app configuration
   - Add redirect logic for unauthorized access attempts

2. **Refactor Route Management**
   - Update GetX route management to support role-based routing
   - Implement transition animations between role-specific screens
   - Add route history management for back navigation

3. **Add Analytics**
   - Implement screen view tracking
   - Add navigation event logging
   - Create funnels for common user journeys

## Technical Implementation Details

### Architecture Updates

```dart
// Role-based theme provider
class ThemeProvider extends GetxController {
  final _currentRole = Rx<UserRole>(UserRole.employee);
  
  ThemeData get currentTheme {
    switch (_currentRole.value) {
      case UserRole.employee:
        return _employeeTheme;
      case UserRole.employer:
        return _employerTheme;
      case UserRole.admin:
        return _adminTheme;
      default:
        return _employeeTheme;
    }
  }
  
  // Theme definitions with role-specific colors
  final _employeeTheme = ThemeData(
    primaryColor: Color(0xFF2563EB),
    // Other theme properties
  );
  
  final _employerTheme = ThemeData(
    primaryColor: Color(0xFF059669),
    // Other theme properties
  );
  
  final _adminTheme = ThemeData(
    primaryColor: Color(0xFF4F46E5),
    // Other theme properties
  );
}
```

### UI Component Library

Create a set of role-adaptive components:

```dart
// Role-adaptive button example
class RoleAdaptiveButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  @override
  Widget build(BuildContext context) {
    final userRole = Get.find<AuthController>().userRole.value;
    final theme = Theme.of(context);
    
    // Apply role-specific styling
    Color buttonColor;
    switch (userRole) {
      case UserRole.employee:
        buttonColor = theme.primaryColor; // Blue
        break;
      case UserRole.employer:
        buttonColor = Color(0xFF059669); // Green
        break;
      case UserRole.admin:
        buttonColor = Color(0xFF4F46E5); // Indigo
        break;
      default:
        buttonColor = theme.primaryColor;
    }
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        // Other style properties
      ),
      child: Text(text),
    );
  }
}
```

## Testing Strategy

1. **Widget Tests**
   - Test role-specific UI components
   - Verify theme application based on role
   - Test navigation components with different roles

2. **Integration Tests**
   - Test role-based navigation flows
   - Verify role switching functionality
   - Test permission handling for protected routes

3. **Accessibility Tests**
   - Verify color contrast for all role-specific themes
   - Test keyboard navigation for all interactive elements
   - Verify screen reader compatibility

## Implementation Timeline

1. **Week 1: Theme and Navigation Setup**
   - Implement theme service and role-specific themes
   - Create navigation components with role adaptation
   - Set up route management with role-based access control

2. **Week 2: Home Screens Development**
   - Implement employee home screen
   - Create employer home screen
   - Develop admin home screen

3. **Week 3: Role Selection and Polish**
   - Enhance role selection experience
   - Implement role switching functionality
   - Add animations and transitions
   - Conduct testing and bug fixes

## Conclusion

This implementation plan provides a structured approach to completing Phase 1 of the UI/UX guidelines. By following these guidelines, we'll establish a solid foundation for role-specific user experiences while maintaining code quality and user satisfaction.
