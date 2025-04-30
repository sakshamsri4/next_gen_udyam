// This file provides interop classes and methods for Firebase Web
// It's used to fix compilation errors when building for web

import 'dart:async';

// Implementation of PromiseJsImpl for Firebase Web SDK
class PromiseJsImpl<T> {
  // Constructor
  PromiseJsImpl();

  // Factory to create a resolved promise
  static PromiseJsImpl<T> resolve<T>(T value) {
    return PromiseJsImpl<T>();
  }

  // Factory to create a rejected promise
  static PromiseJsImpl<T> reject<T>(Object error) {
    return PromiseJsImpl<T>();
  }

  // Then method for promise chaining
  PromiseJsImpl<R> then<R>(
    R Function(T value) onFulfilled, {
    Function? onRejected,
  }) {
    return PromiseJsImpl<R>();
  }

  // Catch method for error handling
  PromiseJsImpl<T> catchError(Function onRejected) {
    // Just return a new instance for the stub implementation
    return PromiseJsImpl<T>();
  }
}

// Utility functions that are missing in the Firebase Web SDK
// These are used by the Firebase Web SDK to convert between Dart and JS objects

// Convert a JS object to a Dart object
dynamic dartify(dynamic jsObject) {
  if (jsObject == null) return null;

  // Handle primitive types
  if (jsObject is num || jsObject is bool || jsObject is String) {
    return jsObject;
  }

  // Handle arrays
  if (jsObject is List) {
    return jsObject.map(dartify).toList();
  }

  // Handle objects
  if (jsObject is Map) {
    return Map.fromEntries(
      jsObject.entries.map(
        (entry) => MapEntry(dartify(entry.key), dartify(entry.value)),
      ),
    );
  }

  // Default case
  return jsObject;
}

// Convert a Dart object to a JS object
dynamic jsify(dynamic dartObject, {Function? customJsify}) {
  if (dartObject == null) return null;

  // Handle primitive types
  if (dartObject is num || dartObject is bool || dartObject is String) {
    return dartObject;
  }

  // Handle arrays
  if (dartObject is List) {
    return dartObject
        .map((item) => jsify(item, customJsify: customJsify))
        .toList();
  }

  // Handle maps
  if (dartObject is Map) {
    final result = <String, dynamic>{};
    for (final entry in dartObject.entries) {
      final key = entry.key.toString();
      final value = jsify(entry.value, customJsify: customJsify);
      result[key] = value;
    }
    return result;
  }

  // Use custom jsify function if provided
  if (customJsify != null) {
    // Cast to a callable function type
    final customFunction = customJsify as Object Function(dynamic);
    return customFunction(dartObject);
  }

  // Default case
  return dartObject;
}

// Handle a thenable (Promise) and convert it to a Dart Future
Future<T> handleThenable<T>(PromiseJsImpl<T> promise) {
  // For our stub implementation, just return a completed future
  // In a real implementation, this would convert a JS Promise to a Dart Future
  return Future<T>.value();
}
