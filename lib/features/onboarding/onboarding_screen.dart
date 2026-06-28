import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FScaffold(
      child: Center(
        child: Padding(
          padding: const .all(24),
          child: Column(
            mainAxisSize: .min,
            spacing: 24,
            children: [
              const Icon(FLucideIcons.sparkles, size: 64),
              Text(
                'Welcome',
                style: FTheme.of(context).typography.display.xl2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Flutter app with router, SQLite, and ForUI. '
                'Get started by exploring your items.',
                textAlign: .center,
                style: FTheme.of(context).typography.body.md.copyWith(
                  color: FTheme.of(context).colors.mutedForeground,
                ),
              ),
              FButton(
                onPress: () async {
                  await ref.read(onboardingProvider.notifier).complete();
                  if (context.mounted) {
                    context.go('/');
                  }
                },
                suffix: const Icon(FLucideIcons.arrowRight),
                child: const Text('Get started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
