import 'package:flutter/foundation.dart';

sealed class LogLevel {
  const LogLevel();
  String get prefix;
  int get priority;
}

class DebugLevel extends LogLevel {
  const DebugLevel();
  @override
  String get prefix => 'DEBUG';
  @override
  int get priority => 0;
}

class InfoLevel extends LogLevel {
  const InfoLevel();
  @override
  String get prefix => 'INFO';
  @override
  int get priority => 1;
}

class WarningLevel extends LogLevel {
  const WarningLevel();
  @override
  String get prefix => 'WARN';
  @override
  int get priority => 2;
}

class ErrorLevel extends LogLevel {
  const ErrorLevel();
  @override
  String get prefix => 'ERROR';
  @override
  int get priority => 3;
}

class AppLogger {
  const AppLogger._();

  static const DebugLevel debug = DebugLevel();
  static const InfoLevel info = InfoLevel();
  static const WarningLevel warning = WarningLevel();
  static const ErrorLevel error = ErrorLevel();

  static const String _appName = 'asheeighe';
  static LogLevel _minLevel = const DebugLevel();

  static void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  static void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (level.priority < _minLevel.priority) return;

    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag]' : '';
    final errorStr = error != null ? ' | Error: $error' : '';
    final stackStr = stackTrace != null ? '\n$stackTrace' : '';

    final logMessage =
        '[$timestamp][$_appName][${level.prefix}]$tagStr $message$errorStr$stackStr';

    if (kDebugMode) {
      switch (level) {
        case DebugLevel():
          debugPrint(logMessage);
        case InfoLevel():
          debugPrint(logMessage);
        case WarningLevel():
          debugPrint(logMessage);
        case ErrorLevel():
          debugPrint(logMessage);
      }
    }
  }

  static void d(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    log(const DebugLevel(), message,
        error: error, stackTrace: stackTrace, tag: tag);
  }

  static void i(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    log(const InfoLevel(), message,
        error: error, stackTrace: stackTrace, tag: tag);
  }

  static void w(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    log(const WarningLevel(), message,
        error: error, stackTrace: stackTrace, tag: tag);
  }

  static void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    log(const ErrorLevel(), message,
        error: error, stackTrace: stackTrace, tag: tag);
  }
}
