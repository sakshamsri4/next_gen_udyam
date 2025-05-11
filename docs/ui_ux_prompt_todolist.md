# Next Gen Udyam - UI/UX Implementation Todo List

This document provides a structured, phased approach to implementing the UI/UX improvements for the Next Gen Udyam job portal application, with specific prompts for each phase.

## Phase 1: Role-Based Architecture Foundation

### 1.1 Role-Specific Navigation Systems (High Priority)

- [ ] **Employee Bottom Navigation**
  - Create `EmployeeBottomNav` widget with blue color scheme (#2563EB)
  - Implement tabs: Home, Search, Saved, Applications, Profile
  - Use job seeker-focused icons from Heroicons
  - Add active/inactive states with proper color transitions
  - Prompt: "Create a blue-themed bottom navigation bar for employee users with tabs for Home, Search, Saved, Applications, and Profile using Heroicons and proper state management"

- [ ] **Employer Bottom Navigation**
  - Create `EmployerBottomNav` widget with green color scheme (#059669)
  - Implement tabs: Dashboard, Jobs, Applicants, Company, Settings
  - Use recruitment-focused icons from Heroicons
  - Add active/inactive states with proper color transitions
  - Prompt: "Create a green-themed bottom navigation bar for employer users with tabs for Dashboard, Jobs, Applicants, Company, and Settings using Heroicons and proper state management"

- [ ] **Admin Navigation**
  - Create `AdminSideNav` widget with indigo color scheme (#4F46E5)
  - Implement items: Dashboard, Users, Content, Settings, Analytics
  - Use administration-focused icons from Heroicons
  - Add active/inactive states with proper color transitions
  - Prompt: "Create an indigo-themed side navigation for admin users with items for Dashboard, Users, Content, Settings, and Analytics using Heroicons and proper state management"

### 1.2 Role-Specific Home Screens (High Priority)

- [ ] **Employee Home Screen**
  - Create `EmployeeHomeView` with job recommendations and activity feed
  - Implement quick search bar and recently viewed jobs section
  - Add application status updates section
  - Use blue color scheme for UI elements
  - Prompt: "Design an employee home screen with job recommendations, quick search, recently viewed jobs, and application updates using the blue color palette (#2563EB)"

- [ ] **Employer Dashboard**
  - Create `EmployerDashboardView` with key metrics and activity overview
  - Implement quick actions section (post job, review applications)
  - Add upcoming interviews and tasks section
  - Use green color scheme for UI elements
  - Prompt: "Design an employer dashboard with key metrics, quick actions, and upcoming tasks using the green color palette (#059669)"

- [ ] **Admin Dashboard**
  - Create `AdminDashboardView` with system metrics and moderation queue
  - Implement user growth and engagement statistics
  - Add recent activity log and quick actions
  - Use indigo color scheme for UI elements
  - Prompt: "Design an admin dashboard with system metrics, moderation queue, and activity log using the indigo color palette (#4F46E5)"

### 1.3 Role Selection Flow (High Priority)

- [ ] **Enhanced Role Selection Screen**
  - Redesign `RoleSelectionView` with clear visual differentiation
  - Create role cards with appropriate illustrations and colors
  - Add role descriptions and confirmation step
  - Implement role change functionality from settings
  - Prompt: "Redesign the role selection screen with visually distinct cards for each role (Employee: blue, Employer: green, Admin: indigo) with illustrations and clear descriptions"

### 1.4 Route Management (High Priority)

- [ ] **Role-Specific Routes**
  - Create `employee_routes.dart`, `employer_routes.dart`, and `admin_routes.dart`
  - Update `app_pages.dart` to use role-specific routes
  - Implement route guards for unauthorized access
  - Add route history management
  - Prompt: "Refactor the routing system to use role-specific route files with proper guards and history management"

## Phase 2: Employee-Specific UI

### 2.1 Job Search Experience (High Priority)

- [ ] **Advanced Search Screen**
  - Create `JobSearchView` with advanced filters and sorting
  - Implement search results with pagination
  - Add saved searches functionality
  - Use blue color scheme for UI elements
  - Prompt: "Design an advanced job search screen with filters, sorting options, and saved searches functionality using the blue color palette"

- [ ] **Job Card Component**
  - Create `JobCard` component with consistent styling
  - Implement quick actions (save, apply, share)
  - Add match percentage based on profile
  - Use blue accents for interactive elements
  - Prompt: "Design a job card component with clear information hierarchy, quick actions, and match percentage using the blue accent colors"

### 2.2 Job Details Screen (High Priority)

- [ ] **Enhanced Job Details**
  - Redesign `JobDetailsView` with clear sections
  - Implement sticky apply button
  - Add company profile preview
  - Include similar jobs section
  - Prompt: "Redesign the job details screen with organized sections, sticky apply button, and similar jobs recommendations using the blue color palette"

### 2.3 Applications Tracking (Medium Priority)

- [ ] **Applications Management**
  - Create `ApplicationsView` with status filters
  - Implement application cards with timeline
  - Add communication history section
  - Include application analytics
  - Prompt: "Design an applications tracking screen with status filters, timeline view, and analytics using the blue color palette"

### 2.4 Employee Profile (Medium Priority)

- [ ] **Profile Management**
  - Enhance `ProfileView` with comprehensive sections
  - Implement resume builder with templates
  - Add skills assessment features
  - Include profile completion indicator
  - Prompt: "Enhance the employee profile screen with resume builder, skills section, and completion indicator using the blue color palette"

## Phase 3: Employer-Specific UI

### 3.1 Job Posting Management (High Priority)

- [ ] **Job Management Screen**
  - Create `JobPostingView` with status filters
  - Implement job posting cards with metrics
  - Add quick actions (edit, pause, duplicate, delete)
  - Include job creation form with templates
  - Prompt: "Design a job posting management screen with status filters, metrics, and quick actions using the green color palette"

### 3.2 Applicant Review System (High Priority)

- [ ] **Applicant Management**
  - Create `ApplicantReviewView` with filtering and sorting
  - Implement applicant cards with summary information
  - Add comparison feature for shortlisting
  - Include communication tools
  - Prompt: "Design an applicant review system with filtering, comparison features, and communication tools using the green color palette"

### 3.3 Company Profile Management (Medium Priority)

- [ ] **Company Profile**
  - Enhance `CompanyProfileView` with comprehensive sections
  - Implement media gallery for company photos
  - Add team members and culture sections
  - Include analytics for profile views
  - Prompt: "Enhance the company profile screen with media gallery, team section, and analytics using the green color palette"

### 3.4 Employer Analytics (Medium Priority)

- [ ] **Analytics Dashboard**
  - Create `EmployerAnalyticsView` with key metrics
  - Implement charts and graphs for job performance
  - Add applicant funnel visualization
  - Include export functionality
  - Prompt: "Design an employer analytics dashboard with charts, applicant funnel, and export functionality using the green color palette"

## Phase 4: Admin-Specific UI

### 4.1 User Management System (Medium Priority)

- [ ] **User Management**
  - Create `UserManagementView` with search and filters
  - Implement user cards with summary information
  - Add role management and permissions
  - Include user analytics and activity logs
  - Prompt: "Design a user management screen with search, role management, and activity logs using the indigo color palette"

### 4.2 Content Moderation Tools (Medium Priority)

- [ ] **Content Moderation**
  - Create `ContentModerationView` with queues
  - Implement moderation cards for different content types
  - Add approval/rejection workflows
  - Include moderation history and audit logs
  - Prompt: "Design a content moderation screen with queues, approval workflows, and audit logs using the indigo color palette"

### 4.3 System Configuration (Low Priority)

- [ ] **System Settings**
  - Create `SystemConfigView` with sections for different settings
  - Implement job categories and skills database management
  - Add feature flags and A/B testing configuration
  - Include system health monitoring
  - Prompt: "Design a system configuration screen with settings sections, database management, and monitoring tools using the indigo color palette"

## Phase 5: Shared Components and Styling

### 5.1 Design System Implementation (High Priority)

- [ ] **Theme Provider**
  - Create comprehensive theme provider with role-specific themes
  - Implement light and dark mode support
  - Add animation system for consistent motion
  - Include accessibility features
  - Prompt: "Implement a theme provider with role-specific color palettes, light/dark mode support, and accessibility features"

- [ ] **Color System**
  - Implement CSS variables or theme objects for color management
  - Create role-specific color palettes
  - Add shared colors for common states
  - Ensure proper contrast ratios
  - Prompt: "Implement a color system with role-specific palettes (Employee: blue, Employer: green, Admin: indigo) and shared state colors"

### 5.2 Component Library (High Priority)

- [ ] **Button Components**
  - Create button variants (primary, secondary, outline, text)
  - Implement role-specific styling
  - Add loading states and disabled states
  - Include icon button variants
  - Prompt: "Create a button component library with variants and role-specific styling using the defined color palettes"

- [ ] **Card Components**
  - Create card variants (basic, interactive, elevated)
  - Implement role-specific styling
  - Add loading states and empty states
  - Include expandable card variants
  - Prompt: "Create a card component library with variants and role-specific styling using the defined color palettes"

- [ ] **Form Components**
  - Create input field variants (text, number, date, select)
  - Implement validation and error states
  - Add role-specific styling
  - Include accessible label and help text
  - Prompt: "Create a form component library with validation, error states, and role-specific styling using the defined color palettes"

### 5.3 Responsive Layout System (Medium Priority)

- [ ] **Responsive Grid**
  - Implement responsive grid system with breakpoints
  - Create container components with appropriate padding
  - Add adaptive layouts for different screen sizes
  - Include orientation-specific layouts
  - Prompt: "Implement a responsive grid system with breakpoints and adaptive layouts for different screen sizes"

## Phase 6: Advanced Features and Polish

### 6.1 Notification System (Low Priority)

- [ ] **Notification Center**
  - Create notification center with categories
  - Implement notification preferences screen
  - Add in-app notification display
  - Include push notification support
  - Prompt: "Design a notification system with categories, preferences, and in-app display using role-specific styling"

### 6.2 Chat and Messaging (Low Priority)

- [ ] **Messaging System**
  - Create conversation list and chat interface
  - Implement attachment support
  - Add read receipts and typing indicators
  - Include message templates
  - Prompt: "Design a messaging system with conversation list, chat interface, and attachment support using role-specific styling"

### 6.3 Onboarding Flows (Low Priority)

- [ ] **Role-Specific Onboarding**
  - Create onboarding flows for each role
  - Implement feature discovery and tooltips
  - Add progress tracking
  - Include personalization options
  - Prompt: "Design role-specific onboarding flows with feature discovery, tooltips, and progress tracking using role-specific styling"

## Implementation Guidelines

- Start with Phase 1 to establish the foundation for role-based UI
- Prioritize high-priority items within each phase
- Complete at least Phase 1 and Phase 5.1 (Design System) before moving to other phases
- Test each component and screen on multiple device sizes
- Document all components in the component library
- Update this todo list as items are completed
