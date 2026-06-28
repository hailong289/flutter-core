# flutter_application_1

Flutter app với nền tảng **core** sẵn sàng mở rộng: điều hướng đa màn hình, lưu trữ SQLite cục bộ, cấu hình `.env`, và UI ForUI.

## Tổng quan

Ứng dụng được xây dựng theo kiến trúc phân lớp: UI → Router → Riverpod → Domain → Data (Drift). Sprint 1 hoàn thành router + SQLite; Sprint 2 thêm domain layer, env config, settings, onboarding và migration DB v2.

## Tech stack

| Hạng mục | Công nghệ |
|----------|-----------|
| Framework | Flutter (Dart `^3.12.2`) |
| UI | [ForUI](https://forui.dev) `^0.23.0` |
| Routing | [go_router](https://pub.dev/packages/go_router) |
| State | [Riverpod](https://riverpod.dev) |
| Database | [Drift](https://drift.simonbinder.eu) (SQLite) |
| Config | [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) |

## Kiến trúc

```
UI (Screens + AppShell)
        ↓
   go_router (+ onboarding redirect)
        ↓
   Riverpod Providers
        ↓
   Domain (entities + repository interfaces)
        ↓
   Data (repository impl + Drift)
```

## Cấu trúc thư mục

```
lib/
├── main.dart                 # loadEnv + ProviderScope
├── app.dart                  # MaterialApp.router + dynamic FTheme
├── router/                   # GoRouter + redirect
├── shell/                    # AppShell
├── core/
│   ├── config/               # .env / EnvConfig
│   ├── database/             # Drift schema v2
│   ├── preferences/          # SharedPreferences keys
│   └── widgets/              # AsyncStateView
├── domain/                   # entities + repository interfaces
├── data/repositories/        # repository implementations
├── providers/                # Riverpod
└── features/
    ├── home/, items/, settings/
    ├── onboarding/
    └── error/
```

## Routing

| Path | Màn hình |
|------|----------|
| `/onboarding` | Onboarding (lần đầu mở app) |
| `/` | Home |
| `/items` | Items list |
| `/items/:id` | Item detail (edit) |
| `/settings` | Settings |
| `/error` | Error fallback |

## Environment (`.env`)

Copy `.env.example` → `.env` trước khi chạy:

```bash
cp .env.example .env
```

```env
APP_ENV=development
API_BASE_URL=https://api.example.com
ENABLE_DEBUG_LOG=true
```

Sau khi sửa `.env`, cần **full restart** (không hot reload).

## Database

- Schema **v2**: `items` (id, title, description, createdAt, updatedAt)
- Migration tự động từ v1
- Export / clear data trong Settings

```bash
dart run build_runner build   # sau khi đổi schema
```

## Chạy & phát triển

```bash
cp .env.example .env
flutter pub get
flutter run
flutter analyze
flutter test
```

## Kế hoạch sprint

| Sprint | Nội dung | Trạng thái |
|--------|----------|------------|
| [Sprint 1](docs/plans/sprint-1-core-router-sqlite.md) | Core Router + SQLite | Hoàn thành |
| [Sprint 2](docs/plans/sprint-2-domain-ux-settings.md) | Domain, UX, Settings, .env, Migration | Hoàn thành |

## Tài liệu tham khảo

- [ForUI docs](https://forui.dev/docs)
- [go_router](https://pub.dev/documentation/go_router/latest/)
- [Drift docs](https://drift.simonbinder.eu/docs/)
- [Riverpod](https://riverpod.dev/docs/introduction/getting_started)
