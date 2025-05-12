# Navigation Improvement Plan

This document outlines the plan to implement the improved navigation structure for the Next Gen Udyam application, focusing on better UX principles and streamlined tab organization.

## Current Issues

1. Too many tabs in the bottom navigation (5 tabs)
2. Lack of clear information architecture
3. Doesn't follow modern design principles
4. Cognitive load on users with redundant navigation options

## Improved Navigation Structure

### Employee Navigation (Blue Theme)

**New 4-Tab Structure:**
1. **Discover** - Combines home feed and recommendations
2. **Jobs** - Combines search and saved jobs in a single tab with segments
3. **Applications** - Track ongoing applications
4. **Profile** - User profile and settings

### Employer Navigation (Green Theme)

**New 4-Tab Structure:**
1. **Dashboard** - Overview with key metrics and quick actions
2. **Jobs** - Manage job postings with status filters
3. **Applicants** - Review and manage all applications
4. **Company** - Company profile and settings combined

## Implementation Plan

### 1. Update Navigation Controllers

1. Modify `NavigationController` to support the new tab structure
2. Update tab indices and navigation logic
3. Add support for segmented views within tabs (especially for Jobs tab)

### 2. Update Employee Bottom Navigation

1. Modify `EmployeeBottomNav` widget to use the new 4-tab structure
2. Update icons to match the new tab concepts
3. Implement proper state management for active tab

### 3. Update Employer Bottom Navigation

1. Modify `EmployerBottomNav` widget to use the new 4-tab structure
2. Update icons to match the new tab concepts
3. Implement proper state management for active tab

### 4. Create New Screen Components

#### Discover Screen (Employee)
1. Create `DiscoverView` that combines elements from the current home screen
2. Add activity feed section
3. Implement job recommendations section
4. Add quick search functionality

#### Jobs Screen (Employee)
1. Create `JobsView` with segmented controller for "Search" and "Saved"
2. Implement tab switching logic
3. Reuse existing search and saved jobs functionality
4. Create smooth transitions between segments

### 5. Update Routing

1. Update `app_pages.dart` to reflect the new navigation structure
2. Update `employee_routes.dart` with the new screen components
3. Update `employer_routes.dart` with the new screen components
4. Implement proper route guards and middleware

### 6. Refactor Existing Code

1. Migrate functionality from the current Home screen to the new Discover screen
2. Combine Search and Saved screens into the new Jobs screen
3. Update references throughout the codebase
4. Fix any broken navigation flows

## Testing Plan

1. Test navigation flow for both user roles
2. Verify that all functionality is preserved in the new structure
3. Test tab switching and segment navigation
4. Verify that deep linking and back navigation work correctly
5. Test on multiple device sizes to ensure responsive design

## Timeline

1. **Day 1:** Update navigation controllers and bottom navigation components
2. **Day 2:** Create new screen components and implement segmented views
3. **Day 3:** Update routing and refactor existing code
4. **Day 4:** Testing and bug fixes

## Success Criteria

1. Reduced cognitive load with fewer primary navigation options
2. All existing functionality preserved and accessible
3. Improved user experience with more intuitive navigation
4. Consistent with modern design principles and patterns
5. Smooth transitions and state preservation between tabs and segments
