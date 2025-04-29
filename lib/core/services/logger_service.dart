import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// A service for logging messages throughout the application.
///
/// This service provides a centralized way to log messages with different
/// levels of severity. It uses the `logger` package to format and output logs.
class LoggerService {
  factory LoggerService() => _instance;
  LoggerService._internal();
  // Singleton pattern
  static final LoggerService _instance = LoggerService._internal();

  // Logger instance with custom configuration
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true, // Should each log print contain a timestamp
    ),
    // Only log in debug mode
    level: kDebugMode ? Level.verbose : Level.nothing,
  );

  /// Log a verbose message.
  ///
  /// Use for detailed information that is only valuable for debugging.
  Future<void> v(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) async {
    _logger.v(message, error: error, stackTrace: stackTrace);
  }

  /// Log a debug message.
  ///
  /// Use for debugging information that may be useful during development.
  void d(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log an info message.
  ///
  /// Use for general information about app operation.
  void i(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log a warning message.
  ///
  /// Use for potentially harmful situations that don't cause immediate errors.
  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log an error message.
  ///
  /// Use for errors that need attention but don't crash the app.
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log a critical error message.
  ///
  /// Use for critical errors that may cause the app to crash.
  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

// Global instance for easy access throughout the app
final log = LoggerService();
