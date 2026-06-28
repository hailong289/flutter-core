import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.empty,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function()? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final Widget Function()? empty;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => loading?.call() ?? const Center(child: FProgress()),
      error: (err, stack) =>
          error?.call(err, stack) ??
          Center(
            child: FAlert(
              variant: .destructive,
              title: const Text('Error'),
              subtitle: Text('$err'),
            ),
          ),
      data: (result) {
        if (result is Iterable && result.isEmpty && empty != null) {
          return empty!();
        }
        return data(result);
      },
    );
  }
}
