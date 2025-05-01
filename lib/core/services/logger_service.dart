import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// A service for logging messages throughout the app
class LoggerService {
  /// Factory constructor to return the singleton instance
  factory LoggerService() => _instance;

  /// Internal constructor
  LoggerService._internal();

  /// Singleton instance
  static final LoggerService _instance = LoggerService._internal();

  /// Logger instance
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kDebugMode ? Level.trace : Level.info,
  );

  /// Log a trace message (formerly verbose)
  void t(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Log a verbose message (deprecated, use t() instead)
  @Deprecated('Use t() instead')
  void v(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Log a debug message

  void d(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void i(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

final log = LoggerService();
