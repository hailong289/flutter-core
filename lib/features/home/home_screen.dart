import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../../router/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        spacing: 16,
        children: [
          Text(
            'Welcome',
            style: FTheme.of(context).typography.display.xl2.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('Core app with router, SQLite & settings'),
          FButton(
            onPress: () => context.go(AppRoutes.items),
            suffix: const Icon(FLucideIcons.arrowRight),
            child: const Text('Go to Items'),
          ),
        ],
      ),
    );
  }
}
