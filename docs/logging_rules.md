# Logging Rules and Best Practices

This document outlines the logging rules and best practices for the Next Gen Job Portal application.

## Logging Levels

The application uses the following logging levels, in order of increasing severity:

1. **Verbose** (`log.v`): Detailed information, only valuable for debugging.
2. **Debug** (`log.d`): Debugging information that may be useful during development.
3. **Info** (`log.i`): General information about app operation.
4. **Warning** (`log.w`): Potentially harmful situations that don't cause immediate errors.
5. **Error** (`log.e`): Errors that need attention but don't crash the app.
6. **Fatal** (`log.wtf`): Critical errors that may cause the app to crash.

## When to Use Each Level

- **Verbose**: Use for tracing code execution or very detailed debugging.
  ```dart
  log.v('Entering method: _handleSignIn');
  ```

- **Debug**: Use for debugging information during development.
  ```dart
  log.d('User input received: $userInput');
  ```

- **Info**: Use for general operational information.
  ```dart
  log.i('User successfully logged in: ${user.email}');
  ```

- **Warning**: Use for potential issues that don't immediately affect functionality.
  ```dart
  log.w('API response slower than expected: ${response.timing}ms');
  ```

- **Error**: Use for errors that need attention.
  ```dart
  log.e('Failed to load user profile', error, stackTrace);
  ```

- **Fatal**: Use for critical errors that may crash the app.
  ```dart
  log.wtf('Database corruption detected', error, stackTrace);
  ```

## Logging Best Practices

1. **Be Descriptive**: Log messages should be clear and descriptive.
   - Bad: `log.i('Success')`
   - Good: `log.i('User registration successful: ${user.email}')`

2. **Include Context**: Include relevant context information in log messages.
   - Bad: `log.e('Error occurred')`
   - Good: `log.e('Failed to fetch user data for ID: $userId', error, stackTrace)`

3. **Don't Log Sensitive Information**: Never log passwords, tokens, or personal information.
   - Bad: `log.d('User password: $password')`
   - Good: `log.d('Password validation completed')`

4. **Log at the Right Level**: Use the appropriate log level for the situation.

5. **Log Exceptions with Stack Traces**: Always include the error object and stack trace when logging exceptions.
   ```dart
   try {
     // Some code that might throw
   } catch (e, stackTrace) {
     log.e('Failed to process payment', e, stackTrace);
   }
   ```

6. **Log State Changes**: Log important state changes in the application.
   ```dart
   log.i('User state changed: ${oldState.status} -> ${newState.status}');
   ```

7. **Log API Interactions**: Log API requests and responses (without sensitive data).
   ```dart
   log.d('API Request: GET /users/$userId');
   log.d('API Response: ${response.statusCode}');
   ```

8. **Use Structured Logging**: For complex data, consider using structured logging.
   ```dart
   log.i('User profile updated: ${jsonEncode(userProfile)}');
   ```

## Implementation in the Codebase

To use the logger in any file:

1. Import the logger service:
   ```dart
   import 'package:next_gen/core/services/logger_service.dart';
   ```

2. Use the global `log` instance:
   ```dart
   log.i('This is an info message');
   ```

## Production Logging

In production builds, only warnings, errors, and fatal logs are recorded. Verbose, debug, and info logs are disabled to improve performance.

## Log Analysis

Logs should be regularly reviewed during development and testing to identify and fix issues. Consider implementing a remote logging solution for production builds to capture and analyze errors that occur in the field.
