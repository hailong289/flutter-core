---
name: flutter-forui
description: >-
  Develop Flutter apps with ForUI in flutter_application_1. Use when adding
  screens, widgets, themes, routing, SQLite/Drift, Riverpod, or features;
  fixing Flutter/ForUI bugs; running builds; or when the user mentions ForUI,
  go_router, Drift, Riverpod, or this Flutter project.
---

# Flutter + ForUI — flutter_application_1

## Project snapshot

| Item | Value |
|------|-------|
| Package | `flutter_application_1` |
| SDK | Dart `^3.12.2` |
| UI | `forui` + `forui_assets` `^0.23.0` |
| Router | `go_router` — `lib/router/app_router.dart` |
| State | `flutter_riverpod` — `lib/providers/` |
| Database | `drift` (SQLite) — `lib/core/database/` |
| Entry | `lib/main.dart` → `lib/app.dart` (`Application`) |
| Shell | `lib/shell/app_shell.dart` (bottom nav / sidebar) |

## Architecture

```
lib/
├── main.dart              # ProviderScope + runApp
├── app.dart               # MaterialApp.router + ForUI wrappers
├── router/                # GoRouter config + route constants
├── shell/                 # AppShell (tab navigation)
├── core/database/         # Drift AppDatabase + tables
├── data/repositories/     # (use providers/repository_providers.dart)
├── providers/             # Riverpod providers
└── features/              # Feature screens by domain
    ├── home/
    ├── items/
    └── settings/
```

## App bootstrap

```dart
// main.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: Application()));
}

// app.dart — ConsumerWidget
MaterialApp.router(
  routerConfig: ref.watch(routerProvider),
  theme: theme.toApproximateMaterialTheme(),
  builder: (_, child) => FTheme(
    data: theme,
    child: FToaster(child: FTooltipGroup(child: child!)),
  ),
);
```

**Required wrappers:** `FTheme`, `FToaster`, `FTooltipGroup` — keep in `app.dart` builder, not per-route.

## Routing (go_router)

Route constants: `lib/router/routes.dart` (`AppRoutes.home`, `.items`, `.settings`).

| Path | Screen |
|------|--------|
| `/` | `HomeScreen` |
| `/items` | `ItemsScreen` |
| `/items/:id` | `ItemDetailScreen` |
| `/settings` | `SettingsScreen` |

- Tab screens live inside `StatefulShellRoute.indexedStack` + `AppShell`.
- Only `AppShell` owns `FScaffold` for tab routes; pushed screens (e.g. detail) may use their own `FScaffold` + `FHeader.nested`.
- Navigate: `context.go(AppRoutes.items)`, `context.push(AppRoutes.itemDetail(id))`, `context.pop()`.

## Database (Drift)

- Schema: `lib/core/database/tables/items.dart`
- DB class: `lib/core/database/app_database.dart` (+ generated `.g.dart`)
- Access via `ItemRepository` → `itemRepositoryProvider` / `itemsStreamProvider`
- Regenerate after schema changes:

```bash
dart run build_runner build
```

- Tests: use in-memory DB — `AppDatabase(NativeDatabase.memory())`

## Riverpod patterns

```dart
// Override DB in widget tests
ProviderScope(
  overrides: [databaseProvider.overrideWithValue(db)],
  child: const Application(),
)

// Stream data from Drift
final itemsStreamProvider = StreamProvider<List<Item>>((ref) {
  return ref.watch(itemRepositoryProvider).watchAll();
});
```

## ForUI conventions

| Material / common | ForUI |
|-------------------|-------|
| `onTap` | `onPress` |
| `Scaffold` | `FScaffold` (shell only for tabs) |
| `Theme.of(context)` | `FTheme.of(context)` |
| `Icons.*` | `FLucideIcons.*` |
| Typography `xl2` | `typography.display.xl2` or `.body.sm` |
| `showFToast(ctx, ...)` | `showFToast(context: ctx, title: ...)` |
| `FTextField(controller:)` | `control: .managed(controller: ctrl)` |
| `FSidebar(child:)` | `FSidebar(children: [...])` |
| `FAlert(child:)` | `FAlert(title:, subtitle:)` |

### Theme

```dart
FThemes.neutral.dark.touch   // mobile
FThemes.neutral.dark.desktop // desktop
```

## Adding a new tab screen

1. Create `lib/features/<name>/<name>_screen.dart`
2. Add route constant in `routes.dart`
3. Add `StatefulShellBranch` in `app_router.dart`
4. Add nav item in `app_shell.dart` (bottom nav + sidebar)

## Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run
dart run build_runner build    # after Drift schema changes
dart run forui theme create neutral
```

## External docs

- ForUI: https://forui.dev/docs
- go_router: https://pub.dev/packages/go_router
- Drift: https://drift.simonbinder.eu/docs/
- Riverpod: https://riverpod.dev

## Additional resources

- Widget catalog: [reference.md](reference.md)
