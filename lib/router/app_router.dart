import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/error/error_screen.dart';
import '../features/home/home_screen.dart';
import '../features/items/item_detail_screen.dart';
import '../features/items/items_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/settings/settings_screen.dart';
import '../providers/database_provider.dart';
import '../providers/onboarding_provider.dart';
import '../shell/app_shell.dart';
import 'routes.dart';

class RouterRefreshListenable extends ChangeNotifier {
  RouterRefreshListenable(this.ref) {
    ref.listen(onboardingProvider, (_, _) => notifyListeners());
  }

  final Ref ref;
}

final routerRefreshProvider = Provider<RouterRefreshListenable>((ref) {
  return RouterRefreshListenable(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  ref.watch(databaseProvider);
  final refresh = ref.watch(routerRefreshProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refresh,
    redirect: (context, state) {
      final onboarding = ref.read(onboardingProvider);
      final location = state.matchedLocation;
      final onOnboarding = location == AppRoutes.onboarding;

      if (onboarding.isLoading) {
        return null;
      }

      final completed = onboarding.value ?? false;
      if (!completed && !onOnboarding) {
        return AppRoutes.onboarding;
      }
      if (completed && onOnboarding) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.error,
        builder: (context, state) => const ErrorScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.items,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ItemsScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return ItemDetailScreen(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
