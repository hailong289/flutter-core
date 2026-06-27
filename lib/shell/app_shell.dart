import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _mobilePlatforms = <TargetPlatform>{
    .android,
    .iOS,
    .fuchsia,
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = _mobilePlatforms.contains(defaultTargetPlatform);

    if (isMobile) {
      return FScaffold(
        footer: FBottomNavigationBar(
          index: navigationShell.currentIndex,
          onChange: navigationShell.goBranch,
          children: const [
            FBottomNavigationBarItem(
              icon: Icon(FLucideIcons.house),
              label: Text('Home'),
            ),
            FBottomNavigationBarItem(
              icon: Icon(FLucideIcons.list),
              label: Text('Items'),
            ),
            FBottomNavigationBarItem(
              icon: Icon(FLucideIcons.settings),
              label: Text('Settings'),
            ),
          ],
        ),
        child: navigationShell,
      );
    }

    return FScaffold(
      sidebar: FSidebar(
        children: [
          for (final (index, icon, label) in _destinations)
            FSidebarItem(
              selected: navigationShell.currentIndex == index,
              icon: Icon(icon),
              label: Text(label),
              onPress: () => navigationShell.goBranch(index),
            ),
        ],
      ),
      child: navigationShell,
    );
  }

  static const _destinations = [
    (0, FLucideIcons.house, 'Home'),
    (1, FLucideIcons.list, 'Items'),
    (2, FLucideIcons.settings, 'Settings'),
  ];
}
