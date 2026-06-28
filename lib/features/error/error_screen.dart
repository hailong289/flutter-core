import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: Center(
        child: Column(
          mainAxisSize: .min,
          spacing: 16,
          children: [
            const Icon(FLucideIcons.circleAlert, size: 48),
            Text(
              'Something went wrong',
              style: FTheme.of(context).typography.display.lg,
            ),
            FButton(
              onPress: () => context.go('/'),
              child: const Text('Go home'),
            ),
          ],
        ),
      ),
    );
  }
}
