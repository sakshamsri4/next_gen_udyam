# Next Gen Job Portal Implementation TODO List

This document outlines the tasks needed to ensure all features are properly implemented and integrated, with a focus on the employee/employer distinction and fixing integration issues.

## Phase 1: Core User Role Implementation

### User Role Selection
- [x] Create a role selection screen to be shown after signup or during onboarding
- [x] Implement role storage in user profile (add `userType` field to UserModel)
- [x] Add role-based routing to direct users to appropriate screens based on their role
- [x] Update AuthController to handle user role selection and persistence
- [x] Create UI components for role selection with CRED-style design

### Fix Home Screen Shimmering Issue
- [x] Debug the persistent shimmer effect on the home screen
- [x] Ensure loading states are properly toggled when data is loaded
- [x] Add timeout handling for loading states to prevent infinite shimmer
- [x] Implement proper error handling for failed data loading

### Role-Based Navigation
- [x] Create separate bottom navigation bars for employee and employer users
- [x] Implement role-based drawer menu with appropriate options
- [x] Add role-specific routes and middleware
- [x] Create role-switching functionality for testing purposes

### Code Quality Checks
- [x] Run `flutter analyze` to identify code issues
- [x] Apply `dart fix --apply` to automatically fix common issues
- [x] Fix any remaining linting warnings and errors
- [x] Ensure proper code formatting with `dart format`
- [x] Review and refactor code for maintainability

## Phase 2: Employee-Specific Features

### Job Search & Application
- [ ] Ensure job search functionality works properly for employees
- [ ] Fix any issues with job application submission
- [ ] Implement application tracking for employees
- [ ] Add notifications for application status changes

### Employee Profile
- [ ] Complete employee profile editing functionality
- [ ] Implement resume upload and management
- [ ] Add skills and experience sections to profile
- [ ] Create profile completeness indicator

### Saved Jobs
- [ ] Fix any issues with saving/unsaving jobs
- [ ] Implement proper synchronization of saved jobs across screens
- [ ] Add filtering and sorting options for saved jobs
- [ ] Create UI for empty saved jobs state

### Code Quality Checks
- [ ] Run `flutter analyze` to identify code issues
- [ ] Apply `dart fix --apply` to automatically fix common issues
- [ ] Fix any remaining linting warnings and errors
- [ ] Ensure proper code formatting with `dart format`
- [ ] Review and refactor code for maintainability

## Phase 3: Employer-Specific Features

### Company Profile
- [ ] Complete company profile creation and editing
- [ ] Implement company logo upload and management
- [ ] Add company verification process
- [ ] Create company profile preview as seen by job seekers

### Job Posting
- [ ] Implement job creation form with validation
- [ ] Add job editing and deletion functionality
- [ ] Create job post preview before publishing
- [ ] Implement job status management (active, paused, closed)

### Applicant Tracking
- [ ] Create applicant list view for each job posting
- [ ] Implement applicant filtering and sorting
- [ ] Add applicant status management (reviewed, shortlisted, rejected)
- [ ] Create applicant profile view with resume download

### Code Quality Checks
- [ ] Run `flutter analyze` to identify code issues
- [ ] Apply `dart fix --apply` to automatically fix common issues
- [ ] Fix any remaining linting warnings and errors
- [ ] Ensure proper code formatting with `dart format`
- [ ] Review and refactor code for maintainability

## Phase 4: Integration & UI Fixes

### Authentication Flow
- [ ] Ensure smooth transition from signup to role selection
- [ ] Fix any issues with Google Sign-In
- [ ] Implement proper error handling for authentication failures
- [ ] Add email verification reminder

### Navigation & Routing
- [ ] Fix any navigation issues between screens
- [ ] Ensure back button behavior is consistent
- [ ] Implement deep linking for notifications
- [ ] Add route guards for authenticated routes

### UI Consistency
- [ ] Apply CRED design principles consistently across all screens
- [ ] Fix any responsive design issues
- [ ] Ensure dark mode works properly on all screens
- [ ] Standardize animations and transitions

### Performance Optimization
- [ ] Fix memory leaks and dispose controllers properly
- [ ] Implement pagination for long lists
- [ ] Optimize image loading and caching
- [ ] Add offline support for critical features

### Code Quality Checks
- [ ] Run `flutter analyze` to identify code issues
- [ ] Apply `dart fix --apply` to automatically fix common issues
- [ ] Fix any remaining linting warnings and errors
- [ ] Ensure proper code formatting with `dart format`
- [ ] Review and refactor code for maintainability

## Phase 5: Testing & Polishing

### Comprehensive Testing
- [ ] Test user registration and role selection
- [ ] Test job search and application as employee
- [ ] Test job posting and applicant management as employer
- [ ] Test profile editing for both roles
- [ ] Test navigation and routing for both roles
- [ ] Test edge cases (no internet, server errors, etc.)

### Final Polishing
- [ ] Add loading indicators where missing
- [ ] Implement proper error states for all screens
- [ ] Add empty states for lists
- [ ] Ensure all animations are smooth
- [ ] Fix any remaining UI inconsistencies

### Final Code Quality Checks
- [ ] Run comprehensive `flutter analyze` on the entire codebase
- [ ] Apply `dart fix --apply` to automatically fix common issues
- [ ] Fix any remaining linting warnings and errors
- [ ] Ensure proper code formatting with `dart format`
- [ ] Conduct code review for maintainability and performance
- [ ] Check for any deprecated API usage
- [ ] Verify proper error handling throughout the app

## Implementation Priority

1. **Critical Issues**
   - Fix home screen shimmering issue
   - Implement user role selection
   - Create role-based navigation

2. **Core Functionality**
   - Complete employee job search and application
   - Implement employer job posting and management
   - Finish profile management for both roles

3. **Enhanced Features**
   - Add applicant tracking for employers
   - Implement resume management for employees
   - Create notifications for both roles

4. **Polish & Optimization**
   - Apply consistent CRED design
   - Optimize performance
   - Add comprehensive error handling
   - Run code quality checks after each phase
