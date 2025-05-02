# Error Handling & Connectivity Module

This document provides an overview of the Error Handling & Connectivity Module implemented in the Next Gen Job Portal app.

## Overview

The Error Handling & Connectivity Module provides a comprehensive system for handling errors and monitoring network connectivity throughout the app. It includes custom error pages, network status monitoring, offline mode capabilities, and user-friendly error messages with NeoPOP styling.

## Components

### Services

1. **ConnectivityService**
   - Monitors network connectivity using `connectivity_plus` and `internet_connection_checker`
   - Provides real-time connectivity status updates
   - Allows manual connectivity checks
   - Broadcasts connectivity changes through a stream

2. **ErrorService**
   - Centralizes error handling throughout the app
   - Displays appropriate UI feedback for different error types
   - Provides methods for showing error dialogs, snackbars, and error pages
   - Handles navigation to error pages

3. **GlobalErrorHandler**
   - Catches and handles errors at the application level
   - Integrates with Flutter's error handling mechanisms
   - Provides user-friendly error messages
   - Logs errors for debugging

### Controllers

1. **ErrorController**
   - Manages error state using GetX
   - Provides reactive error information
   - Handles retry functionality
   - Integrates with ConnectivityService for network status

### Views

1. **ErrorView**
   - Displays error information with NeoPOP styling
   - Shows network status when offline
   - Provides retry options
   - Adapts to different screen sizes

### Widgets

1. **CustomErrorWidget**
   - Reusable widget for displaying errors with consistent styling
   - Supports animations, retry functionality, and error codes
   - Responsive design for different screen sizes

2. **NetworkStatusWidget**
   - Shows current network status
   - Provides reconnect option
   - Can be positioned at top or bottom of the screen

3. **NetworkAwareWidget**
   - Wrapper that shows different content based on connectivity
   - Supports online, offline, and loading states
   - Can show offline content as an overlay or replacement

4. **OfflineWidget**
   - Displays when the app is offline
   - Provides retry option
   - Shows animation and user-friendly message

5. **CustomSnackbar**
   - Utility for showing styled snackbars with different types
   - Supports success, error, warning, and info messages
   - Uses `awesome_snackbar_content` for better visual feedback

## Usage Examples

### Monitoring Network Connectivity

```dart
// Get the current connectivity status
final connectivityService = Get.find<ConnectivityService>();
final status = connectivityService.status;

// Listen for connectivity changes
connectivityService.connectivityStream.listen((status) {
  if (status == ConnectivityStatus.online) {
    // Handle online state
  } else {
    // Handle offline state
  }
});

// Manually check connectivity
await connectivityService.checkConnection();
```

### Handling Errors

```dart
// Using ErrorService
final errorService = Get.find<ErrorService>();

// Show an error dialog
errorService.handleError(
  error,
  stackTrace,
  friendlyMessage: 'Something went wrong',
  showDialog: true,
);

// Navigate to error page
errorService.navigateToErrorPage(
  title: 'Error',
  message: 'An error occurred',
  errorCode: 'E123',
  onRetry: () => fetchData(),
);

// Show a snackbar
errorService.showErrorSnackbar(
  title: 'Error',
  message: 'Failed to load data',
);
```

### Using NetworkAwareWidget

```dart
NetworkAwareWidget(
  onlineChild: YourContentWidget(),
  offlineChild: OfflineWidget(
    onRetry: () => fetchData(),
  ),
  loadingChild: CircularProgressIndicator(),
)
```

### Using CustomSnackbar

```dart
// Show a success snackbar
CustomSnackbar.showSuccess(
  title: 'Success',
  message: 'Data saved successfully',
);

// Show an error snackbar
CustomSnackbar.showError(
  title: 'Error',
  message: 'Failed to save data',
);

// Show a network error snackbar
CustomSnackbar.showNetworkError(
  onRetry: () => fetchData(),
);
```

## Integration with App

The Error Handling & Connectivity Module is integrated with the app in the following ways:

1. **Initialization in bootstrap.dart**
   - ConnectivityService and ErrorService are initialized during app startup
   - GlobalErrorHandler is set up to catch and handle errors

2. **Error Routes**
   - Error pages are registered in app_routes.dart
   - ErrorBinding ensures all required dependencies are registered

3. **App Widget**
   - GlobalErrorHandler is initialized in the App widget
   - Error handling is set up for the entire app

## Best Practices

1. **Error Handling**
   - Use try-catch blocks for all async operations
   - Provide user-friendly error messages
   - Log errors for debugging
   - Handle different error types appropriately

2. **Connectivity**
   - Check connectivity before making network requests
   - Provide offline functionality where possible
   - Show clear feedback when offline
   - Allow users to retry operations when back online

3. **UI Feedback**
   - Use consistent error UI across the app
   - Provide retry options for recoverable errors
   - Show appropriate loading indicators
   - Use animations to improve user experience

## Future Improvements

1. **Offline Data Synchronization**
   - Implement a queue system for operations when offline
   - Sync data when back online

2. **Enhanced Error Analytics**
   - Integrate with Firebase Crashlytics or similar service
   - Track error frequency and patterns

3. **Expanded Offline Capabilities**
   - Cache more data for offline use
   - Implement offline-first architecture

4. **Improved Error Recovery**
   - Add more sophisticated retry mechanisms
   - Implement circuit breaker pattern for network requests
