import 'dart:developer' as developer;

/// Debug-only logger to avoid print statements in production builds.
const bool _isProduction = bool.fromEnvironment('dart.vm.product');

void logDebug(
  Object? message, {
  Object? error,
  StackTrace? stackTrace,
  String name = 'medita_bk',
}) {
  if (_isProduction) return;
  developer.log(
    message?.toString() ?? 'null',
    name: name,
    error: error,
    stackTrace: stackTrace,
  );
}
