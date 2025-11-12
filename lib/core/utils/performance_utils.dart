import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Performance utilities for optimization
class PerformanceUtils {
  PerformanceUtils._();

  /// Debounce function calls
  static void debounce({
    required VoidCallback callback,
    Duration delay = const Duration(milliseconds: 300),
  }) {
    Future.delayed(delay, callback);
  }

  /// Log performance metrics in debug mode
  static void logPerformance(String label, VoidCallback callback) {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      callback();
      stopwatch.stop();
      debugPrint('[$label] took ${stopwatch.elapsedMilliseconds}ms');
    } else {
      callback();
    }
  }

  /// Measure async operation performance
  static Future<T> measureAsync<T>(
    String label,
    Future<T> Function() callback,
  ) async {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      final result = await callback();
      stopwatch.stop();
      debugPrint('[$label] took ${stopwatch.elapsedMilliseconds}ms');
      return result;
    }
    return callback();
  }
}

/// Mixin for widgets that need performance optimization
mixin PerformanceOptimizationMixin<T extends StatefulWidget> on State<T> {
  /// Override to provide list of dependencies for rebuild optimization
  List<Object?> get dependencies => [];

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (kDebugMode) {
      debugPrint('${widget.runtimeType} rebuilt');
    }
  }
}

/// Throttle helper for limiting function calls
class Throttle {
  Throttle({
    required this.duration,
  });

  final Duration duration;
  bool _isReady = true;

  void call(VoidCallback callback) {
    if (_isReady) {
      _isReady = false;
      callback();
      Future.delayed(duration, () => _isReady = true);
    }
  }
}

/// Debounce helper for delaying function calls
class Debounce {
  Debounce({
    required this.duration,
  });

  final Duration duration;
  VoidCallback? _callback;
  bool _isWaiting = false;

  void call(VoidCallback callback) {
    _callback = callback;
    if (!_isWaiting) {
      _isWaiting = true;
      Future.delayed(duration, () {
        _callback?.call();
        _isWaiting = false;
      });
    }
  }

  void cancel() {
    _callback = null;
  }
}

/// Performance monitoring widget (debug only)
class PerformanceMonitor extends StatelessWidget {
  const PerformanceMonitor({
    super.key,
    required this.child,
    this.label,
  });

  final Widget child;
  final String? label;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      return _PerformanceWrapper(
        label: label ?? 'Widget',
        child: child,
      );
    }
    return child;
  }
}

class _PerformanceWrapper extends StatefulWidget {
  const _PerformanceWrapper({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  State<_PerformanceWrapper> createState() => _PerformanceWrapperState();
}

class _PerformanceWrapperState extends State<_PerformanceWrapper> {
  int _buildCount = 0;

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    if (kDebugMode) {
      debugPrint('[${widget.label}] Build count: $_buildCount');
    }
    return widget.child;
  }
}

/// Lazy initialization helper
class LazyInitializer<T> {
  LazyInitializer(this._initializer);

  final T Function() _initializer;
  T? _value;
  bool _isInitialized = false;

  T get value {
    if (!_isInitialized) {
      _value = _initializer();
      _isInitialized = true;
    }
    return _value!;
  }

  bool get isInitialized => _isInitialized;

  void reset() {
    _value = null;
    _isInitialized = false;
  }
}

/// Memoization helper for expensive computations
class Memoizer<T> {
  final Map<String, T> _cache = {};

  T call(String key, T Function() computation) {
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }
    final result = computation();
    _cache[key] = result;
    return result;
  }

  void clear() {
    _cache.clear();
  }

  void remove(String key) {
    _cache.remove(key);
  }
}

/// Widget that only rebuilds when specified dependencies change
class SelectiveBuilder extends StatefulWidget {
  const SelectiveBuilder({
    super.key,
    required this.builder,
    required this.dependencies,
  });

  final Widget Function(BuildContext context) builder;
  final List<Object?> dependencies;

  @override
  State<SelectiveBuilder> createState() => _SelectiveBuilderState();
}

class _SelectiveBuilderState extends State<SelectiveBuilder> {
  late List<Object?> _previousDependencies;

  @override
  void initState() {
    super.initState();
    _previousDependencies = List.from(widget.dependencies);
  }

  @override
  void didUpdateWidget(SelectiveBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if dependencies changed
    bool hasChanged = false;
    if (widget.dependencies.length != _previousDependencies.length) {
      hasChanged = true;
    } else {
      for (int i = 0; i < widget.dependencies.length; i++) {
        if (widget.dependencies[i] != _previousDependencies[i]) {
          hasChanged = true;
          break;
        }
      }
    }

    if (!hasChanged && kDebugMode) {
      debugPrint('SelectiveBuilder: Skipped rebuild - no dependency changes');
    }

    _previousDependencies = List.from(widget.dependencies);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
