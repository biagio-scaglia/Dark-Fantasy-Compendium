import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../utils/logger.dart';

/// Global error handler for Flutter errors and async exceptions
class AppErrorHandler {
  static final AppErrorHandler _instance = AppErrorHandler._internal();
  factory AppErrorHandler() => _instance;
  AppErrorHandler._internal();

  bool _initialized = false;
  FlutterErrorDetails? _lastError;

  /// Initialize error handlers
  void initialize() {
    if (_initialized) return;

    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    // Handle async errors outside Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      _handleAsyncError(error, stack);
      return true;
    };

    _initialized = true;
    AppLogger.info('Error handler initialized');
  }

  /// Handle Flutter framework errors
  void _handleFlutterError(FlutterErrorDetails details) {
    _lastError = details;
    
    AppLogger.error(
      'Flutter Error: ${details.exception}',
      details.exception,
      details.stack,
    );

    // In debug mode, show red screen
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  }

  /// Handle async errors
  bool _handleAsyncError(Object error, StackTrace stack) {
    AppLogger.error(
      'Async Error: $error',
      error,
      stack,
    );
    return true;
  }

  /// Handle zone errors
  static void handleZoneError(Object error, StackTrace stack) {
    AppErrorHandler()._handleAsyncError(error, stack);
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(dynamic error) {
    if (error is FormatException) {
      return 'Invalid data format. Please check your input.';
    }
    if (error is FileSystemException) {
      return 'File operation failed. Please try again.';
    }
    if (error is Exception) {
      final message = error.toString();
      if (message.contains('encryption')) {
        return 'Security error. Please restart the app.';
      }
      if (message.contains('network') || message.contains('connection')) {
        return 'Connection error. Please check your internet connection.';
      }
      if (message.contains('permission')) {
        return 'Permission denied. Please grant required permissions.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }

  /// Show error dialog
  static Future<void> showErrorDialog(
    BuildContext context,
    String message, {
    String? title,
    VoidCallback? onRetry,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Error'),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Get last error
  FlutterErrorDetails? getLastError() => _lastError;
}

/// Safe async wrapper
Future<T?> safeAsync<T>(
  Future<T> Function() operation, {
  T? defaultValue,
  String? errorMessage,
}) async {
  try {
    return await operation();
  } catch (e, stack) {
    AppLogger.error(
      errorMessage ?? 'Async operation failed',
      e,
      stack,
    );
    return defaultValue;
  }
}

/// Safe sync wrapper
T? safeSync<T>(
  T Function() operation, {
  T? defaultValue,
  String? errorMessage,
}) {
  try {
    return operation();
  } catch (e, stack) {
    AppLogger.error(
      errorMessage ?? 'Sync operation failed',
      e,
      stack,
    );
    return defaultValue;
  }
}


