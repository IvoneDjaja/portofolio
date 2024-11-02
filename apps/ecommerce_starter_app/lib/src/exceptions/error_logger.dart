import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    debugPrint('$error, $stackTrace');
  }
}

final errorLoggerProvider = Provider<ErrorLogger>((ref) {
  return ErrorLogger();
});
