---
name: flutter-forui
description: >-
  Develop Flutter apps with ForUI in flutter_application_1. Use when adding
  screens, widgets, themes, routing, SQLite/Drift, Riverpod, .env config, or
  features; fixing Flutter/ForUI bugs; running builds; or when the user mentions
  ForUI, go_router, Drift, Riverpod, dotenv, or this Flutter project.
---

# Flutter + ForUI — flutter_application_1

## Project snapshot

| Item | Value |
|------|-------|
| Package | `flutter_application_1` |
| SDK | Dart `^3.12.2` |
| UI | `forui` + `forui_assets` `^0.23.0` |
| Router | `go_router` — redirect onboarding |
| State | `flutter_riverpod` — `lib/providers/` |
| Database | `drift` schema v2 — `lib/core/database/` |
| Config | `.env` via `flutter_dotenv` — `lib/core/config/` |
| Domain | `lib/domain/` entities + repository interfaces |
| Entry | `lib/main.dart` → `loadEnv()` → `Application` |

## Architecture

```
lib/
├── main.dart              # loadEnv + ProviderScope + registerPathProvider
├── app.dart               # fThemeDataProvider + MaterialApp.router
├── router/                # GoRouter + onboarding redirect
├── shell/                 # AppShell
├── core/
│   ├── config/            # EnvConfig, loadEnv()
│   ├── database/          # Drift — tables/, daos/, migrations/
│   ├── preferences/       # SharedPreferences keys
│   └── widgets/           # AsyncStateView
├── domain/                # entities + repository interfaces
├── data/repositories/     # ItemRepositoryImpl
├── providers/             # env, theme, onboarding, DB, repos
└── features/              # home, items, settings, onboarding, error
```

## App bootstrap

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();
  registerPathProvider();
  runApp(const ProviderScope(child: Application()));
}
```

Theme is dynamic via `fThemeDataProvider` (light/dark/system from Settings).

## Routing

| Path | Screen |
|------|--------|
| `/onboarding` | First launch |
| `/` | Home |
| `/items` | Items list |
| `/items/:id` | Item detail (edit) |
| `/settings` | Settings |
| `/error` | Error page |

Redirect: chưa onboarding → `/onboarding`. Dùng `refreshListenable` khi onboarding hoàn thành.

## Environment

- `.env` — local only (gitignored)
- `.env.example` — template committed
- `envProvider` → `EnvConfig` (appEnv, apiBaseUrl, enableDebugLog)
- Settings hiển thị env khi không phải production

## Domain + Data

```dart
// domain/repositories/item_repository.dart — interface
// data/repositories/item_repository_impl.dart — Drift mapping
// domain/entities/item.dart — pure Dart entity (not drift.Item)
```

## AsyncStateView

```dart
AsyncStateView<List<Item>>(
  value: ref.watch(itemsStreamProvider),
  onRetry: () => ref.invalidate(itemsStreamProvider),
  empty: () => EmptyWidget(),
  data: (items) => ItemsList(items: items),
)
```

## Database

- Schema v2: `description`, `updatedAt` columns
- `dart run build_runner build` after schema changes
- Tests: `AppDatabase(NativeDatabase.memory())`

## Settings features

- Theme: system / light / dark (`themeModeProvider`)
- DB path, item count, export `.sqlite`, clear all items
- App version via `package_info_plus`

## Commands

```bash
cp .env.example .env
flutter pub get
flutter run
flutter analyze
flutter test
dart run build_runner build
```

## Additional resources

- Widget catalog: [reference.md](reference.md)
