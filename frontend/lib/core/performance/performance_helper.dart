import 'dart:async';
import 'package:flutter/foundation.dart';

/// Performance helper utilities
class PerformanceHelper {
  /// Debounce function calls
  static Timer? _debounceTimer;

  static void debounce(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }

  /// Throttle function calls
  static DateTime? _lastThrottleCall;
  static Timer? _throttleTimer;

  static void throttle(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    final now = DateTime.now();
    if (_lastThrottleCall == null ||
        now.difference(_lastThrottleCall!) >= delay) {
      _lastThrottleCall = now;
      callback();
    } else {
      _throttleTimer?.cancel();
      _throttleTimer = Timer(
        delay - now.difference(_lastThrottleCall!),
        callback,
      );
    }
  }

  /// Run expensive computation in isolate
  static Future<R> computeInIsolate<Q, R>(
    ComputeCallback<Q, R> callback,
    Q message, {
    String? debugLabel,
  }) async {
    return await compute(callback, message, debugLabel: debugLabel);
  }

  /// Clear all timers
  static void dispose() {
    _debounceTimer?.cancel();
    _throttleTimer?.cancel();
    _debounceTimer = null;
    _throttleTimer = null;
  }
}

/// Debouncer class for reusable debouncing
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}

/// Throttler class for reusable throttling
class Throttler {
  final Duration delay;
  DateTime? _lastCall;
  Timer? _timer;

  Throttler({this.delay = const Duration(milliseconds: 300)});

  void call(VoidCallback callback) {
    final now = DateTime.now();
    if (_lastCall == null || now.difference(_lastCall!) >= delay) {
      _lastCall = now;
      callback();
    } else {
      _timer?.cancel();
      _timer = Timer(
        delay - now.difference(_lastCall!),
        callback,
      );
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}


