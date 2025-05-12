# Manual Testing Checklist

This document provides a comprehensive checklist for manual testing of the Next Gen Job Portal app. Use this checklist to ensure all features are working correctly before release.

## Authentication

### Registration
- [ ] Register as an employee with valid credentials
- [ ] Register as an employer with valid credentials
- [ ] Verify form validation for invalid inputs
- [ ] Verify email verification process
- [ ] Verify role selection persistence

### Login
- [ ] Login with valid employee credentials
- [ ] Login with valid employer credentials
- [ ] Verify "Remember Me" functionality
- [ ] Verify "Forgot Password" flow
- [ ] Verify Google Sign-In functionality
- [ ] Verify error messages for invalid credentials

### Account Management
- [ ] Change password
- [ ] Update email address
- [ ] Verify email verification for updated email
- [ ] Sign out
- [ ] Verify persistent login across app restarts

## Employee Features

### Job Search
- [ ] Search for jobs with various keywords
- [ ] Apply filters (location, salary, job type)
- [ ] Sort jobs by different criteria
- [ ] Verify search history functionality
- [ ] Verify empty search results state
- [ ] Test search with special characters

### Job Details
- [ ] View job details
- [ ] View company information
- [ ] View similar jobs
- [ ] Share job listing
- [ ] Save job to favorites
- [ ] Apply for job

### Job Application
- [ ] Fill out application form
- [ ] Upload resume
- [ ] Submit application
- [ ] Verify application confirmation
- [ ] Verify applying for already applied job
- [ ] Verify form validation

### Saved Jobs
- [ ] Save jobs to favorites
- [ ] View all saved jobs
- [ ] Filter and sort saved jobs
- [ ] Remove jobs from favorites
- [ ] Verify empty saved jobs state
- [ ] Verify saved jobs persistence across sessions

### Applications
- [ ] View all applications
- [ ] Filter applications by status
- [ ] View application details
- [ ] Withdraw an application
- [ ] Verify empty applications state
- [ ] Verify application status updates

### Profile Management
- [ ] Create/edit profile
- [ ] Upload profile picture
- [ ] Add/edit skills and experience
- [ ] Upload/update resume
- [ ] Verify profile form validation
- [ ] Verify profile visibility to employers

## Employer Features

### Job Posting
- [ ] Create a new job posting
- [ ] Edit an existing job posting
- [ ] Change job status (active, closed, draft)
- [ ] Delete a job posting
- [ ] Verify job posting form validation
- [ ] Verify job posting with various job types

### Applicant Management
- [ ] View all applicants for a job
- [ ] Filter applicants by status
- [ ] View applicant details and resume
- [ ] Change applicant status (accept, reject, pending)
- [ ] Verify empty applicants state
- [ ] Verify applicant sorting options

### Company Profile
- [ ] Create/edit company profile
- [ ] Upload company logo
- [ ] Add company details (description, industry, etc.)
- [ ] Verify company profile form validation
- [ ] Verify company profile visibility to job seekers

## Navigation and UI

### Navigation
- [ ] Test bottom navigation bar for employee
- [ ] Test bottom navigation bar for employer
- [ ] Test drawer navigation
- [ ] Verify correct screen transitions
- [ ] Test back button behavior
- [ ] Test deep linking

### UI Components
- [ ] Verify all buttons are clickable and functional
- [ ] Verify all forms have proper validation
- [ ] Verify all error messages are displayed correctly
- [ ] Verify all loading indicators are displayed correctly
- [ ] Verify all empty states are displayed correctly
- [ ] Verify all animations are smooth

### Responsiveness
- [ ] Test on small phone screens
- [ ] Test on large phone screens
- [ ] Test on tablets
- [ ] Test in portrait orientation
- [ ] Test in landscape orientation
- [ ] Verify text scaling works correctly

### Themes
- [ ] Test light theme
- [ ] Test dark theme
- [ ] Verify theme switching
- [ ] Verify all UI elements are visible in both themes
- [ ] Verify all text is readable in both themes
- [ ] Verify all icons are visible in both themes

## Edge Cases

### Network Conditions
- [ ] Test with no internet connection
- [ ] Test with slow internet connection
- [ ] Test when connection is lost during operation
- [ ] Test when connection is restored
- [ ] Verify offline mode functionality
- [ ] Verify error messages for network issues

### Error Handling
- [ ] Test with server errors (500)
- [ ] Test with client errors (400)
- [ ] Test with authentication errors
- [ ] Test with Firebase errors
- [ ] Verify error messages and retry functionality
- [ ] Verify logging for errors

### Data Integrity
- [ ] Test with corrupted local data
- [ ] Test with missing data
- [ ] Test with unexpected data formats
- [ ] Verify data synchronization after offline operations
- [ ] Verify data persistence across app restarts
- [ ] Verify data validation before submission

## Performance

### Load Testing
- [ ] Test with large number of jobs
- [ ] Test with large number of applications
- [ ] Test with large number of saved jobs
- [ ] Test with large profile data
- [ ] Verify scrolling performance with large lists
- [ ] Verify search performance with large datasets

### Memory Usage
- [ ] Monitor memory usage during extended use
- [ ] Check for memory leaks
- [ ] Verify resources are properly disposed
- [ ] Test app after extended background time
- [ ] Verify app performance after multiple restarts
- [ ] Test app behavior with low memory conditions

### Battery Usage
- [ ] Monitor battery usage during extended use
- [ ] Verify background processes are optimized
- [ ] Test location services impact on battery
- [ ] Test network operations impact on battery
- [ ] Verify app behavior in low power mode
- [ ] Test app with battery saver enabled

## Accessibility

### Screen Reader Support
- [ ] Test with screen readers (TalkBack/VoiceOver)
- [ ] Verify all UI elements have proper accessibility labels
- [ ] Test navigation flow with screen readers
- [ ] Verify form inputs are accessible
- [ ] Verify error messages are announced
- [ ] Test custom widgets for accessibility

### Visual Accessibility
- [ ] Test with different text sizes
- [ ] Test with high contrast mode
- [ ] Verify color contrast meets accessibility standards
- [ ] Test with reduced motion settings
- [ ] Verify touch targets are large enough
- [ ] Test with screen magnification

## Final Verification

### Cross-Platform Testing
- [ ] Test on Android devices
- [ ] Test on iOS devices
- [ ] Verify consistent behavior across platforms
- [ ] Test on different OS versions
- [ ] Verify platform-specific features
- [ ] Test with different device capabilities

### Regression Testing
- [ ] Verify all previously fixed bugs remain fixed
- [ ] Test critical user flows end-to-end
- [ ] Verify all features from previous versions still work
- [ ] Test integration points between modules
- [ ] Verify data consistency across features
- [ ] Test upgrade path from previous versions
