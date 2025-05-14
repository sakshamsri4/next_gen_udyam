# Playwright Testing To-Do for Next Gen Job Portal

## Overview
This document outlines the testing plan for the Next Gen Job Portal Flutter web application using Playwright. The testing will focus on identifying and fixing issues in the application flow, particularly around authentication, role selection, and navigation.

## Setup

### Prerequisites
- Node.js installed
- Playwright installed (`npm init playwright@latest`)
- Chrome browser installed
- Flutter app running on web server

### Initial Setup Tasks
- [ ] Create a Playwright test directory
- [ ] Configure Playwright for Chrome testing
- [ ] Set up test environment variables for test accounts
- [ ] Create helper functions for common operations (login, signup, etc.)

## Test Scenarios

### 1. Application Initialization
- [ ] Test application loading
  - [ ] Verify the loading indicator appears
  - [ ] Verify the app initializes Firebase correctly
  - [ ] Check for any console errors during initialization
  - [ ] Verify the app transitions from loading to the first screen

### 2. Authentication Flow
- [ ] Test login functionality
  - [ ] Verify login form validation
  - [ ] Test login with valid credentials
  - [ ] Test login with invalid credentials
  - [ ] Test error messages for various login failure scenarios
  - [ ] Verify navigation after successful login

- [ ] Test signup functionality
  - [ ] Verify signup form validation
  - [ ] Test signup with new email
  - [ ] Verify email verification process
  - [ ] Test navigation after successful signup
  - [ ] Verify transition to role selection after signup

- [ ] Test Google Sign-In
  - [ ] Verify Google Sign-In popup appears
  - [ ] Test successful Google authentication
  - [ ] Verify handling of Google Sign-In errors

- [ ] Test password reset flow
  - [ ] Verify forgot password form
  - [ ] Test sending reset email
  - [ ] Verify reset email confirmation

### 3. Role Selection
- [ ] Test role selection screen
  - [ ] Verify all three roles are displayed (Job Seeker, Employer, Admin)
  - [ ] Test selecting each role
  - [ ] Verify role confirmation dialog
  - [ ] Test navigation after role selection
  - [ ] Verify theme changes based on selected role

### 4. Navigation and Routing
- [ ] Test navigation based on user role
  - [ ] Verify correct navigation components for each role
  - [ ] Test navigation between different sections
  - [ ] Verify protected routes redirect appropriately
  - [ ] Test back button behavior

### 5. Dashboard and Main Features
- [ ] Test employee (job seeker) flow
  - [ ] Verify job listings display
  - [ ] Test job search functionality
  - [ ] Test job application process
  - [ ] Verify saved jobs functionality

- [ ] Test employer flow
  - [ ] Verify company profile
  - [ ] Test job posting functionality
  - [ ] Test applicant review system

- [ ] Test admin flow
  - [ ] Verify admin dashboard
  - [ ] Test user management features
  - [ ] Test content moderation tools

## Known Issues to Verify

### Authentication Issues
- [ ] Verify if there are issues with Google Sign-In configuration
- [ ] Check for proper error handling during authentication
- [ ] Test for any LateInitializationError in authentication flow

### Role Selection Issues
- [ ] Verify if users get stuck on signup page
- [ ] Test navigation from signup to role selection
- [ ] Check if role is properly saved and persisted

### Firebase Issues
- [ ] Check for Firebase initialization errors
- [ ] Verify Firestore data handling
- [ ] Test Firebase Storage operations

### UI/UX Issues
- [ ] Check for ScreenUtil initialization errors
- [ ] Verify responsive design on different screen sizes
- [ ] Test theme changes based on user role

## Test Execution Plan

### Phase 1: Basic Functionality Testing
- [ ] Set up test environment
- [ ] Create basic test scripts for authentication
- [ ] Run tests on Chrome
- [ ] Document initial findings

### Phase 2: Issue Identification
- [ ] Run comprehensive tests on all flows
- [ ] Capture screenshots/videos of issues
- [ ] Categorize issues by severity
- [ ] Create detailed issue reports

### Phase 3: Issue Resolution
- [ ] Fix identified issues in the codebase
- [ ] Verify fixes with targeted tests
- [ ] Regression test to ensure no new issues

### Phase 4: Final Verification
- [ ] Run full test suite on Chrome
- [ ] Verify all critical paths work correctly
- [ ] Document any remaining issues

## Reporting

### Test Report Structure
- [ ] Summary of test execution
- [ ] List of identified issues
- [ ] Screenshots/videos of issues
- [ ] Recommendations for fixes
- [ ] Metrics (pass/fail rate, test coverage)

## Automation Scripts

### Basic Authentication Test
```javascript
// Example Playwright test for login
test('should login with valid credentials', async ({ page }) => {
  await page.goto('http://localhost:8080/');
  await page.waitForSelector('text=SIGN IN');
  
  // Fill login form
  await page.fill('input[type="email"]', 'test@example.com');
  await page.fill('input[type="password"]', 'password123');
  
  // Click login button
  await page.click('text=SIGN IN');
  
  // Verify successful login
  await page.waitForSelector('text=Dashboard');
});
```

### Role Selection Test
```javascript
// Example Playwright test for role selection
test('should select job seeker role', async ({ page }) => {
  // Assume user is logged in and on role selection page
  await page.waitForSelector('text=Select Your Role');
  
  // Select job seeker role
  await page.click('text=Job Seeker');
  
  // Confirm selection
  await page.click('text=Continue');
  
  // Verify confirmation dialog
  await page.waitForSelector('text=Confirm Role Selection');
  await page.click('text=Confirm');
  
  // Verify navigation to dashboard
  await page.waitForSelector('text=Dashboard');
});
```

## Next Steps
After completing the testing and fixing identified issues, we should:
1. Set up continuous integration for automated testing
2. Create a regression test suite
3. Implement performance testing
4. Consider cross-browser testing
