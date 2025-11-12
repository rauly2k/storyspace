import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'error_display.dart';

/// Reusable widget to handle AsyncValue states elegantly
class AsyncValueHandler<T> extends StatelessWidget {
  const AsyncValueHandler({
    super.key,
    required this.asyncValue,
    required this.dataBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.onRetry,
    this.skipLoadingOnRefresh = true,
  });

  final AsyncValue<T> asyncValue;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, Object error, StackTrace? stack)?
      errorBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final VoidCallback? onRetry;
  final bool skipLoadingOnRefresh;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: (data) => _handleData(context, data),
      loading: () => _handleLoading(context),
      error: (error, stack) => _handleError(context, error, stack),
      skipLoadingOnRefresh: skipLoadingOnRefresh,
    );
  }

  Widget _handleData(BuildContext context, T data) {
    // Check if data is empty list
    if (data is List && (data as List).isEmpty && emptyBuilder != null) {
      return emptyBuilder!(context);
    }
    return dataBuilder(context, data);
  }

  Widget _handleLoading(BuildContext context) {
    if (loadingBuilder != null) {
      return loadingBuilder!(context);
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _handleError(BuildContext context, Object error, StackTrace? stack) {
    if (errorBuilder != null) {
      return errorBuilder!(context, error, stack);
    }
    return AsyncErrorDisplay(
      error: error,
      onRetry: onRetry,
    );
  }
}

/// Builder widget for AsyncValue with custom loading/error states
class AsyncValueBuilder<T> extends StatelessWidget {
  const AsyncValueBuilder({
    super.key,
    required this.asyncValue,
    required this.data,
    this.loading,
    this.error,
    this.skipLoadingOnRefresh = true,
  });

  final AsyncValue<T> asyncValue;
  final Widget Function(T data) data;
  final Widget Function()? loading;
  final Widget Function(Object error, StackTrace? stack)? error;
  final bool skipLoadingOnRefresh;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: data,
      loading: loading ?? () => const Center(child: CircularProgressIndicator()),
      error: error ??
          (err, stack) => AsyncErrorDisplay(
                error: err,
              ),
      skipLoadingOnRefresh: skipLoadingOnRefresh,
    );
  }
}

/// Sliver version of AsyncValueHandler
class SliverAsyncValueHandler<T> extends StatelessWidget {
  const SliverAsyncValueHandler({
    super.key,
    required this.asyncValue,
    required this.dataBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.onRetry,
  });

  final AsyncValue<T> asyncValue;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, Object error, StackTrace? stack)?
      errorBuilder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: (data) => dataBuilder(context, data),
      loading: () => SliverFillRemaining(
        child: loadingBuilder?.call(context) ??
            const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SliverFillRemaining(
        child: errorBuilder?.call(context, error, stack) ??
            AsyncErrorDisplay(
              error: error,
              onRetry: onRetry,
            ),
      ),
    );
  }
}

/// Widget to handle loading overlay on top of existing content
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.opacity = 0.7,
  });

  final bool isLoading;
  final Widget child;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: opacity),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

/// Widget for handling pull-to-refresh with AsyncValue
class AsyncRefreshIndicator<T> extends StatelessWidget {
  const AsyncRefreshIndicator({
    super.key,
    required this.asyncValue,
    required this.onRefresh,
    required this.child,
  });

  final AsyncValue<T> asyncValue;
  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: child,
    );
  }
}
