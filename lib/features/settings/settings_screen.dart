import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../providers/env_provider.dart';
import '../../providers/theme_provider.dart';
import 'settings_actions.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(envProvider);
    final themeMode = ref.watch(themeModeProvider);
    final packageInfo = ref.watch(packageInfoProvider);
    final itemCount = ref.watch(itemCountProvider);
    final dbPath = ref.watch(databasePathProvider);

    return ListView(
      padding: const .all(16),
      children: [
        Text(
          'Settings',
          style: FTheme.of(context).typography.display.xl2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _Section(
          title: 'Appearance',
          child: themeMode.when(
            loading: () => const FProgress(),
            error: (e, _) => Text('$e'),
            data: (mode) => Column(
              spacing: 8,
              children: [
                for (final option in AppThemeMode.values)
                  FItem(
                    title: Text(_themeLabel(option)),
                    selected: mode == option,
                    onPress: () =>
                        ref.read(themeModeProvider.notifier).setMode(option),
                  ),
              ],
            ),
          ),
        ),
        if (!env.isProduction) ...[
          _Section(
            title: 'Environment',
            child: Column(
              crossAxisAlignment: .start,
              spacing: 4,
              children: [
                Text('APP_ENV: ${env.appEnv}'),
                Text('API_BASE_URL: ${env.apiBaseUrl}'),
                Text('DEBUG_LOG: ${env.enableDebugLog}'),
              ],
            ),
          ),
        ],
        _Section(
          title: 'Database',
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 8,
            children: [
              dbPath.when(
                loading: () => const Text('Loading path...'),
                error: (e, _) => Text('$e'),
                data: (path) => Text(
                  path,
                  style: FTheme.of(context).typography.body.xs,
                ),
              ),
              itemCount.when(
                loading: () => const Text('Counting items...'),
                error: (e, _) => Text('$e'),
                data: (count) => Text('Items: $count'),
              ),
              FButton(
                onPress: () async {
                  try {
                    await exportDatabaseFile();
                    if (context.mounted) {
                      showFToast(
                        context: context,
                        title: const Text('Database exported'),
                      );
                    }
                  } on Object catch (error) {
                    if (context.mounted) {
                      showFToast(
                        context: context,
                        title: Text('Export failed: $error'),
                      );
                    }
                  }
                },
                suffix: const Icon(FLucideIcons.download),
                child: const Text('Export database'),
              ),
              FButton(
                variant: .destructive,
                onPress: () async {
                  final confirmed = await showFDialog<bool>(
                    context: context,
                    builder: (context, style, animation) => FDialog(
                      animation: animation,
                      style: style,
                      title: const Text('Clear all items?'),
                      body: const Text('All items will be permanently deleted.'),
                      actions: [
                        FButton(
                          onPress: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        FButton(
                          variant: .destructive,
                          onPress: () => Navigator.of(context).pop(true),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await clearAllItems(ref);
                    if (context.mounted) {
                      showFToast(
                        context: context,
                        title: const Text('All items cleared'),
                      );
                    }
                  }
                },
                child: const Text('Clear all items'),
              ),
            ],
          ),
        ),
        _Section(
          title: 'About',
          child: packageInfo.when(
            loading: () => const Text('Loading version...'),
            error: (e, _) => Text('$e'),
            data: (info) => Text(
              '${info.appName} ${info.version}+${info.buildNumber}',
            ),
          ),
        ),
      ],
    );
  }

  String _themeLabel(AppThemeMode mode) => switch (mode) {
    AppThemeMode.system => 'System',
    AppThemeMode.light => 'Light',
    AppThemeMode.dark => 'Dark',
  };
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 24),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: 8,
        children: [
          Text(
            title,
            style: FTheme.of(context).typography.body.lg.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
