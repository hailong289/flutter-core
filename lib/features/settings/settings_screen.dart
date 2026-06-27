import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        spacing: 8,
        children: [
          const Icon(FLucideIcons.settings, size: 48),
          Text(
            'Settings',
            style: FTheme.of(context).typography.display.xl2,
          ),
          Text(
            'Placeholder — sprint 2',
            style: FTheme.of(context).typography.body.sm.copyWith(
              color: FTheme.of(context).colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
