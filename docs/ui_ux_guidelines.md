# Next Gen Udyam - UI/UX Guidelines

This document outlines the UI/UX guidelines for the Next Gen Udyam job portal application. It provides a comprehensive framework for implementing role-specific interfaces and improving the overall user experience.

## Core Design Principles

1. **Role-Based Design**
   - Each user role (Employee, Employer, Admin) should have a dedicated UI tailored to their specific needs
   - Navigation, content, and functionality should be optimized for each role's primary tasks
   - Visual language should clearly communicate the current role context
   - Use distinct color schemes for each role to provide immediate visual identification

2. **Consistent Visual Language**
   - Use a consistent color palette, typography, and component styling across the app
   - Maintain consistent spacing, alignment, and visual hierarchy
   - Ensure interactive elements (buttons, links, inputs) have consistent behavior and appearance

3. **Clear Information Hierarchy**
   - Organize content with clear visual hierarchy to guide users' attention
   - Use typography scale to differentiate between primary, secondary, and tertiary information
   - Group related information and actions to create logical content blocks

4. **Responsive and Adaptive Design**
   - Design for all screen sizes (mobile, tablet, desktop) with appropriate layouts
   - Adapt UI components based on available screen space
   - Ensure touch targets are appropriately sized for mobile devices

5. **Accessibility First**
   - Maintain sufficient color contrast (WCAG AA compliance minimum)
   - Support text scaling and screen readers
   - Provide alternative text for images and icons
   - Ensure keyboard navigability for all interactive elements

## Role-Specific UI Architecture

### Employee (Job Seeker) Interface

#### Primary Navigation
- **Home**: Personalized job recommendations and activity feed
- **Search**: Advanced job search with filters and saved searches
- **Saved**: Bookmarked jobs and saved searches
- **Applications**: Application tracking and history
- **Profile**: Personal profile and resume management

#### Key Screens
1. **Home Screen**
   - Personalized job recommendations based on profile and history
   - Recently viewed jobs
   - Application status updates
   - Quick search bar
   - Job market insights relevant to the user's field

2. **Job Search Screen**
   - Prominent search bar with advanced filters
   - Filter chips for quick refinement
   - Sort options (relevance, date, salary)
   - Search results with clear job cards
   - Save search functionality

3. **Job Details Screen**
   - Clear job title, company, and key details at the top
   - Organized sections for description, requirements, benefits
   - Company information with option to view full company profile
   - Prominent apply button (sticky on scroll)
   - Similar jobs recommendations

4. **Applications Screen**
   - Status-based tabs (Applied, In Review, Interviews, Offers, Rejected)
   - Application cards with key information and status
   - Timeline view of application progress
   - Communication history with employers
   - Application analytics (response rate, interview conversion)

5. **Profile Screen**
   - Profile completeness indicator
   - Resume builder and management
   - Skills and experience sections
   - Education and certifications
   - Privacy settings and visibility controls

### Employer Interface

#### Primary Navigation
- **Dashboard**: Key metrics and activity overview
- **Jobs**: Job posting management
- **Applicants**: Applicant tracking and management
- **Company**: Company profile management
- **Settings**: Account and notification settings

#### Key Screens
1. **Dashboard Screen**
   - Key metrics (job views, applications, conversion rates)
   - Recent activity feed
   - Quick actions (post job, review applications)
   - Upcoming interviews and tasks
   - Performance insights and recommendations

2. **Job Management Screen**
   - Status-based tabs (Active, Paused, Draft, Closed)
   - Job posting cards with key metrics
   - Quick actions (edit, pause, duplicate, delete)
   - Analytics for each job posting
   - Job creation and editing interface

3. **Applicant Review Screen**
   - Applicant pipeline visualization
   - Filtering and sorting options
   - Applicant cards with summary information
   - Comparison view for shortlisting
   - Communication tools and status management

4. **Company Profile Screen**
   - Company information and branding
   - Team members and structure
   - Culture and benefits showcase
   - Media gallery for company photos and videos
   - Analytics for profile views and engagement

### Admin Interface

#### Primary Navigation
- **Dashboard**: System overview and key metrics
- **Users**: User management and moderation
- **Content**: Content moderation and management
- **Settings**: System configuration and settings
- **Analytics**: Comprehensive system analytics

#### Key Screens
1. **Admin Dashboard**
   - System health metrics
   - User growth and engagement statistics
   - Content moderation queue status
   - Recent activity log
   - Quick actions for common administrative tasks

2. **User Management Screen**
   - User search and filtering
   - User cards with summary information
   - Role management and permissions
   - Account verification and moderation tools
   - User activity logs and analytics

3. **Content Moderation Screen**
   - Moderation queues for different content types
   - Content review interface with approval/rejection actions
   - Flagged content management
   - Automated moderation settings
   - Moderation history and audit logs

## Component Design Guidelines

### Job Cards
- **Employee View**:
  - Clear job title and company name
  - Key details (location, salary, job type)
  - Company logo or avatar
  - Posted date and application deadline
  - Quick actions (save, apply)
  - Match percentage based on profile (if applicable)

- **Employer View**:
  - Job title and status indicator
  - Key metrics (views, applications, days active)
  - Quick actions (edit, pause, duplicate, delete)
  - Performance indicator compared to similar jobs
  - Application count with trend indicator

### Profile Cards
- **Employee Profile**:
  - Professional photo or avatar
  - Name and headline
  - Key skills and experience summary
  - Education highlights
  - Availability status
  - Profile completeness indicator

- **Company Profile**:
  - Company logo
  - Company name and industry
  - Brief description
  - Key facts (size, location, founded)
  - Verification badge (if verified)
  - Rating or reviews summary (if applicable)

### Action Buttons
- **Primary Actions**: High-visibility buttons with brand colors
- **Secondary Actions**: Less prominent styling but still clearly interactive
- **Destructive Actions**: Distinctive styling (usually red) with confirmation
- **Quick Actions**: Icon buttons with tooltips for common actions
- **Loading States**: All buttons should have clear loading states

### Form Components
- **Input Fields**: Clear labels, validation, and error states
- **Dropdowns**: Searchable for long lists, with clear selected state
- **Checkboxes/Radios**: Adequate spacing and touch targets
- **Date Pickers**: Intuitive calendar interface with range selection
- **File Uploads**: Clear upload area with progress indication and preview

## Implementation Roadmap

### Phase 1: Foundation
1. Create role-specific navigation systems with distinct visual styling:
   - Employee navigation: Blue-themed with job seeker-focused icons
   - Employer navigation: Green-themed with recruitment-focused icons
   - Admin navigation: Indigo-themed with administration-focused icons
2. Implement basic home screens for each role with role-appropriate content and color schemes
3. Update role selection flow with clear visual differentiation between roles
4. Refactor route management for role-based navigation

### Phase 2: Employee Experience
1. Enhance job search experience
2. Redesign job details screen
3. Improve applications tracking
4. Upgrade employee profile management

### Phase 3: Employer Experience
1. Develop job posting management
2. Create applicant review system
3. Enhance company profile management
4. Implement employer analytics dashboard

### Phase 4: Admin Tools
1. Build user management system
2. Develop content moderation tools
3. Create system configuration interface

### Phase 5: Shared Components
1. Implement comprehensive design system
2. Create reusable component library
3. Develop responsive layout system

### Phase 6: Polish and Advanced Features
1. Add notification system
2. Implement messaging functionality
3. Create role-specific onboarding flows
4. Optimize performance and animations

## Role-Specific Color Palettes

To provide clear visual differentiation between user roles, each role should have its own distinct color palette while maintaining overall brand consistency.

### Employee (Job Seeker) Color Palette
- **Primary Color**: Blue (#2563EB)
  - Primary Light: #93C5FD
  - Primary Dark: #1E40AF
- **Secondary Color**: Teal (#0D9488)
  - Secondary Light: #5EEAD4
  - Secondary Dark: #0F766E
- **Accent Color**: Purple (#9333EA)
- **Background**: Light gray (#F9FAFB) for light mode, Dark blue-gray (#1F2937) for dark mode
- **Surface**: White (#FFFFFF) for light mode, Dark gray (#374151) for dark mode
- **Use Cases**: Job cards, search filters, application status indicators

### Employer Color Palette
- **Primary Color**: Green (#059669)
  - Primary Light: #6EE7B7
  - Primary Dark: #065F46
- **Secondary Color**: Amber (#D97706)
  - Secondary Light: #FCD34D
  - Secondary Dark: #92400E
- **Accent Color**: Red (#DC2626)
- **Background**: Light warm gray (#F8FAFC) for light mode, Dark warm gray (#1E293B) for dark mode
- **Surface**: White (#FFFFFF) for light mode, Dark slate (#334155) for dark mode
- **Use Cases**: Job posting cards, applicant pipeline, analytics dashboards

### Admin Color Palette
- **Primary Color**: Indigo (#4F46E5)
  - Primary Light: #A5B4FC
  - Primary Dark: #3730A3
- **Secondary Color**: Rose (#E11D48)
  - Secondary Light: #FDA4AF
  - Secondary Dark: #9F1239
- **Accent Color**: Amber (#F59E0B)
- **Background**: Cool gray (#F3F4F6) for light mode, Dark cool gray (#111827) for dark mode
- **Surface**: White (#FFFFFF) for light mode, Dark gray (#1F2937) for dark mode
- **Use Cases**: System status indicators, moderation tools, user management

### Shared Colors
- **Success**: Green (#10B981)
- **Warning**: Amber (#F59E0B)
- **Error**: Red (#EF4444)
- **Info**: Blue (#3B82F6)
- **Text**: Dark gray (#1F2937) for light mode, White (#F9FAFB) for dark mode
- **Disabled**: Gray (#9CA3AF)

### Implementation Guidelines
- Use CSS variables or theme objects to manage color palettes
- Ensure sufficient contrast ratios for accessibility (minimum 4.5:1 for normal text)
- Apply role-specific colors consistently across all screens for that role
- Use color to reinforce the user's current context, not just for decoration
- Include color-blind friendly alternatives (patterns, icons) for critical UI elements

### Role Indicators in UI
- **App Bar/Header**: Include a subtle role indicator in the app bar (color, icon, or text label)
- **Profile Menu**: Show the current role with an option to switch roles (if applicable)
- **Splash Screen**: Use role-specific colors and imagery on the splash screen after login
- **Loading Indicators**: Customize loading animations with role-specific colors
- **Empty States**: Design role-specific empty state illustrations that reflect the user's context

## Design Handoff Guidelines

When implementing these designs:

1. **Component-First Approach**
   - Build and test individual components before assembling screens
   - Create a component library with variants and states
   - Document component usage and properties

2. **Responsive Implementation**
   - Test on multiple device sizes during development
   - Use relative units (%, rem, vh/vw) instead of fixed pixels
   - Implement breakpoints consistently

3. **State Management**
   - Define all possible UI states (loading, empty, error, success)
   - Create skeleton loaders for content-heavy screens
   - Implement proper error handling with user-friendly messages

4. **Accessibility Verification**
   - Test color contrast for all text elements
   - Ensure proper semantic HTML structure
   - Verify keyboard navigation works for all interactive elements
   - Test with screen readers

5. **Performance Considerations**
   - Optimize image loading and caching
   - Implement virtualized lists for long scrolling content
   - Use code splitting to reduce initial load time
   - Monitor and optimize render performance
