# Next Gen Udyam Project - Todo List

This document outlines the identified issues in the project that need to be fixed. The issues are categorized by type and priority.

## Navigation Issues

1. **Bottom Navigation Bar State Management**
   - Issue: The `RoleBasedBottomNav` widget has state management issues where `setState()` is called during build
   - Fix: The current implementation in `role_based_bottom_nav.dart` uses `Future.microtask` to schedule setState calls, but there might still be edge cases causing issues
   - Priority: High

2. **Navigation Controller Index Synchronization**
   - Issue: The selected index in `NavigationController` doesn't always match the current route
   - Fix: Ensure proper synchronization between routes and tab indices in all views
   - Priority: High

3. **Route Middleware Execution Order**
   - Issue: Middleware priority might not be properly respected in some routes
   - Fix: Review all route definitions and ensure middleware priorities are correctly set
   - Priority: Medium

4. **Drawer Toggle Issues**
   - Issue: The drawer toggle functionality in `NavigationController` might not work consistently across all screens
   - Fix: Ensure each screen properly initializes and uses the scaffold key
   - Priority: Medium

5. **Deep Linking Support**
   - Issue: The app doesn't properly handle deep links
   - Fix: Implement proper deep linking support with route parameters
   - Priority: Low

## Authentication Issues

1. **Google Sign-In Configuration**
   - Issue: Google Sign-In fails with error code 10 (configuration issue)
   - Fix: Properly register SHA-1 certificate fingerprint in Firebase console and ensure correct package name configuration
   - Priority: High

2. **Email Verification Flow**
   - Issue: Email verification banner might not be properly displayed or dismissed
   - Fix: Ensure proper state management for email verification banner visibility
   - Priority: Medium

3. **Role Selection After Signup**
   - Issue: Users might get stuck after signup without being able to select a role
   - Fix: Implement proper role selection flow after signup
   - Priority: High

4. **Persistent Login Issues**
   - Issue: The app might not properly restore user sessions after restart
   - Fix: Ensure proper session restoration in `AuthController._checkPersistedLogin()`
   - Priority: High

5. **Sign Out Loading State**
   - Issue: Loading indicator might persist after sign out
   - Fix: Ensure all loading states are properly reset in `AuthController.signOut()`
   - Priority: Medium

## State Management Issues

1. **GetX Controller Registration**
   - Issue: Controllers might not be properly registered or found when needed
   - Fix: Ensure consistent controller registration approach (either with `Get.put()` or service locator)
   - Priority: High

2. **Observable State Updates**
   - Issue: Observable state variables might be updated during build phase
   - Fix: Ensure state updates happen outside the build phase
   - Priority: High

3. **Nested Obx Widgets**
   - Issue: Nested Obx widgets might cause "improper use of GetX" errors
   - Fix: Avoid nesting Obx widgets and use a single Obx for observing multiple values
   - Priority: Medium

4. **Controller Lifecycle Management**
   - Issue: Controllers might not be properly disposed or reinitialized
   - Fix: Ensure proper lifecycle management for all controllers
   - Priority: Medium

## Storage and Database Issues

1. **Hive Initialization**
   - Issue: Hive database might not be properly initialized before use
   - Fix: Ensure HiveManager is properly initialized in bootstrap.dart
   - Priority: High

2. **Hive Type Adapter Registration**
   - Issue: Type adapters for custom objects like SignupSession might not be registered
   - Fix: Ensure all Hive type adapters are properly registered before use
   - Priority: High

3. **Firestore Data Handling**
   - Issue: Firestore data might not be properly handled (missing null checks, Timestamp conversion)
   - Fix: Add proper null safety checks and Timestamp conversion in all Firestore operations
   - Priority: Medium

4. **User Data Synchronization**
   - Issue: User data might not be properly synchronized between Firebase and local storage
   - Fix: Ensure consistent data synchronization in AuthService
   - Priority: Medium

## UI Issues

1. **Layout Overflow in Signup View**
   - Issue: The signup view has layout overflow issues
   - Fix: Properly handle overflow in all UI components
   - Priority: Medium

2. **Responsive Design Issues**
   - Issue: Some screens might not be properly responsive on different screen sizes
   - Fix: Ensure proper responsive design using ScreenUtil and ResponsiveBuilder
   - Priority: Medium

3. **Loading Indicators Consistency**
   - Issue: Loading indicators might have inconsistent styling across the app
   - Fix: Standardize loading indicator styling and behavior
   - Priority: Low

4. **Empty States Handling**
   - Issue: Empty states might not be properly handled in list views
   - Fix: Add proper empty state widgets for all list views
   - Priority: Low

## Service Initialization Issues

1. **Firebase Initialization**
   - Issue: Firebase services might not be properly initialized
   - Fix: Ensure proper initialization sequence in bootstrap.dart
   - Priority: High

2. **Service Locator Registration**
   - Issue: Services might not be properly registered with GetIt service locator
   - Fix: Ensure consistent service registration approach
   - Priority: High

3. **Connectivity Service**
   - Issue: ConnectivityService might not be properly registered or initialized
   - Fix: Ensure proper registration and initialization in bootstrap.dart
   - Priority: Medium

4. **Error Service**
   - Issue: ErrorService might not be properly handling all error cases
   - Fix: Enhance error handling and reporting
   - Priority: Medium

## Code Quality Issues

1. **Duplicate Code**
   - Issue: There might be duplicate code for similar functionality
   - Fix: Refactor common functionality into shared methods or classes
   - Priority: Medium

2. **Error Handling**
   - Issue: Error handling might not be consistent across the app
   - Fix: Implement consistent error handling strategy
   - Priority: Medium

3. **Logging**
   - Issue: Logging might not be comprehensive or consistent
   - Fix: Ensure proper logging for all important operations
   - Priority: Low

4. **Code Comments**
   - Issue: Some code might lack proper documentation
   - Fix: Add comprehensive comments for complex logic
   - Priority: Low

## Performance Issues

1. **Unnecessary Rebuilds**
   - Issue: Widgets might rebuild unnecessarily due to improper state management
   - Fix: Optimize state management to minimize rebuilds
   - Priority: Medium

2. **Memory Leaks**
   - Issue: Controllers or streams might not be properly disposed
   - Fix: Ensure proper disposal of all resources
   - Priority: Medium

3. **Image Caching**
   - Issue: Images might not be properly cached
   - Fix: Ensure proper image caching strategy
   - Priority: Low

## Testing Issues

1. **Insufficient Test Coverage**
   - Issue: The app might have insufficient test coverage
   - Fix: Increase test coverage for critical functionality
   - Priority: Medium

2. **Flaky Tests**
   - Issue: Some tests might be flaky or inconsistent
   - Fix: Improve test reliability
   - Priority: Low

## Next Steps

1. Start by addressing high-priority issues first, particularly:
   - Navigation and state management issues
   - Authentication flow problems
   - Hive initialization and type adapter registration
   - Service locator registration

2. After fixing high-priority issues, move on to medium and low-priority issues.

3. For each issue:
   - Create a detailed plan for the fix
   - Implement the fix
   - Test thoroughly
   - Document the changes in the activity log
