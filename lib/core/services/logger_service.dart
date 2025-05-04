import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

/// A service for logging messages throughout the app
class LoggerService {
  /// Constructor
  LoggerService() {
    _initLogger();
  }

  /// Logger instance
  late final Logger _logger;

  /// File output for logs in non-debug mode
  StreamController<OutputEvent>? _fileOutput;

  /// Log file path
  String? _logFilePath;

  /// Initialize the logger
  Future<void> _initLogger() async {
    // Create a custom log filter
    final logFilter = _CustomLogFilter(
      level: kDebugMode ? Level.trace : Level.info,
    );

    // Create a pretty printer for console output
    final prettyPrinter = PrettyPrinter(
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    );

    // Create outputs
    final consoleOutput = ConsoleOutput();

    // In non-debug mode, also log to file
    if (!kDebugMode) {
      try {
        await _setupFileLogging();
      } catch (e) {
        // If file logging setup fails, just log to console
        debugPrint('Failed to set up file logging: $e');
      }
    }

    // Create the logger
    _logger = Logger(
      filter: logFilter,
      printer: prettyPrinter,
      output: _fileOutput != null
          ? MultiOutput([consoleOutput, _FileOutput(_fileOutput!)])
          : consoleOutput,
    );

    // Log initialization
    i('Logger initialized');
    if (_logFilePath != null) {
      i('Logging to file: $_logFilePath');
    }
  }

  /// Set up file logging
  Future<void> _setupFileLogging() async {
    if (kIsWeb) return; // File logging not supported on web

    try {
      // Get the documents directory
      final directory = await path_provider.getApplicationDocumentsDirectory();

      // Create a logs directory if it doesn't exist
      final logsDir = Directory('${directory.path}/logs');
      if (!logsDir.existsSync()) {
        logsDir.createSync(recursive: true);
      }

      // Create a log file with the current date
      final now = DateTime.now();
      final fileName = 'log_${now.year}-${now.month}-${now.day}.txt';
      _logFilePath = '${logsDir.path}/$fileName';

      // Create a stream controller for log events
      _fileOutput = StreamController<OutputEvent>.broadcast();

      // Listen to the stream and write to the file
      _fileOutput!.stream.listen((event) async {
        try {
          final file = File(_logFilePath!);
          final sink = file.openWrite(mode: FileMode.append)
            ..writeln(event.lines.join('\n'));
          await sink.flush();
          await sink.close();
        } catch (e) {
          debugPrint('Error writing to log file: $e');
        }
      });
    } catch (e) {
      debugPrint('Error setting up file logging: $e');
      _fileOutput = null;
      _logFilePath = null;
    }
  }

  /// Get the log file path
  String? get logFilePath => _logFilePath;

  /// Read the log file
  Future<String> readLogFile() async {
    if (_logFilePath == null) return 'No log file available';

    try {
      final file = File(_logFilePath!);
      if (file.existsSync()) {
        return await file.readAsString();
      }
      return 'Log file not found';
    } catch (e) {
      return 'Error reading log file: $e';
    }
  }

  /// Clear the log file
  Future<void> clearLogFile() async {
    if (_logFilePath == null) return;

    try {
      final file = File(_logFilePath!);
      if (file.existsSync()) {
        await file.writeAsString('');
        i('Log file cleared');
      }
    } catch (e, stackTrace) {
      this.e('Error clearing log file', e, stackTrace);
    }
  }

  /// Log a trace message
  void t(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null) {
      final errorMsg = stackTrace != null
          ? '$message\nError: $error\n$stackTrace'
          : '$message\nError: $error';
      _logger.t(errorMsg);
    } else {
      _logger.t(message);
    }
  }

  /// Log a verbose message (deprecated, use t() instead)
  @Deprecated('Use t() instead')
  void v(String message, [dynamic error, StackTrace? stackTrace]) {
    t(message, error, stackTrace);
  }

  /// Log a debug message
  void d(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null) {
      final errorMsg = stackTrace != null
          ? '$message\nError: $error\n$stackTrace'
          : '$message\nError: $error';
      _logger.d(errorMsg);
    } else {
      _logger.d(message);
    }
  }

  /// Log an info message
  void i(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null) {
      final errorMsg = stackTrace != null
          ? '$message\nError: $error\n$stackTrace'
          : '$message\nError: $error';
      _logger.i(errorMsg);
    } else {
      _logger.i(message);
    }
  }

  /// Log a warning message
  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null) {
      final errorMsg = stackTrace != null
          ? '$message\nError: $error\n$stackTrace'
          : '$message\nError: $error';
      _logger.w(errorMsg);
    } else {
      _logger.w(message);
    }
  }

  /// Log an error message
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null) {
      final errorMsg = stackTrace != null
          ? '$message\nError: $error\n$stackTrace'
          : '$message\nError: $error';
      _logger.e(errorMsg);
    } else {
      _logger.e(message);
    }
  }

  /// Log a fatal error message
  void f(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null) {
      final errorMsg = stackTrace != null
          ? '$message\nError: $error\n$stackTrace'
          : '$message\nError: $error';
      _logger.f(errorMsg);
    } else {
      _logger.f(message);
    }
  }

  /// Log a fatal error message (deprecated, use f() instead)
  @Deprecated('Use f() instead')
  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    f(message, error, stackTrace);
  }

  /// Log an object as JSON
  void json(String message, Object object) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(object);
      d('$message\n$jsonString');
    } catch (e, stackTrace) {
      this.e('Error logging JSON', e, stackTrace);
    }
  }
}

/// Custom log filter
class _CustomLogFilter extends LogFilter {
  _CustomLogFilter({required Level level}) {
    _level = level;
  }

  late final Level _level;

  @override
  bool shouldLog(LogEvent event) {
    return event.level.index >= _level.index;
  }
}

/// File output for logger
class _FileOutput extends LogOutput {
  _FileOutput(this.controller);

  final StreamController<OutputEvent> controller;

  @override
  void output(OutputEvent event) {
    controller.add(event);
  }
}

/// Global logger instance for easy access
final log = LoggerService();
