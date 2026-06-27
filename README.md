# flutter_application_1

Flutter app với nền tảng **core** sẵn sàng mở rộng: điều hướng đa màn hình, lưu trữ SQLite cục bộ, và UI ForUI.

## Tổng quan

Ứng dụng được xây dựng theo kiến trúc phân lớp, tách biệt UI, routing, state management và data layer. Sprint 1 đã hoàn thành phần nền — router, database, shell navigation — để các feature tiếp theo có thể phát triển độc lập mà không phải setup lại từ đầu.

## Tech stack

| Hạng mục | Công nghệ |
|----------|-----------|
| Framework | Flutter (Dart `^3.12.2`) |
| UI | [ForUI](https://forui.dev) `^0.23.0` |
| Routing | [go_router](https://pub.dev/packages/go_router) |
| State | [Riverpod](https://riverpod.dev) |
| Database | [Drift](https://drift.simonbinder.eu) (SQLite) |

## Kiến trúc

```
UI (Screens + AppShell)
        ↓
   go_router
        ↓
   Riverpod Providers
        ↓
   Repositories
        ↓
   Drift / SQLite
```

**Luồng khởi động:** `main.dart` → `ProviderScope` → `Application` (`MaterialApp.router`) → `GoRouter` → màn hình trong `AppShell`.

## Cấu trúc thư mục

```
lib/
├── main.dart                 # Entry point, đăng ký plugin & ProviderScope
├── app.dart                  # MaterialApp.router + ForUI theme wrappers
├── router/                   # GoRouter config & route constants
├── shell/                    # AppShell — bottom nav (mobile) / sidebar (desktop)
├── core/
│   ├── database/             # Drift schema, connection, generated code
│   └── platform/             # Đăng ký platform plugins
├── providers/                # Riverpod providers (DB, repositories)
└── features/                 # Màn hình theo feature
    ├── home/
    ├── items/                # Demo CRUD SQLite
    └── settings/
```

## Routing

| Path | Màn hình | Mô tả |
|------|----------|-------|
| `/` | Home | Trang chào mừng |
| `/items` | Items | Danh sách item từ SQLite |
| `/items/:id` | Item Detail | Chi tiết item (push navigation) |
| `/settings` | Settings | Placeholder |

Ba tab chính (`/`, `/items`, `/settings`) nằm trong `StatefulShellRoute` — chuyển tab giữ nguyên state từng màn hình.

## Database

- **Engine:** SQLite qua Drift
- **File:** `app.sqlite` trong thư mục documents của app
- **Bảng mẫu:** `items` (id, title, createdAt) — thay bằng domain thật ở sprint sau
- **Truy cập:** `ItemRepository` → `itemsStreamProvider` (reactive stream)

Sau khi thay đổi schema, chạy code generation:

```bash
dart run build_runner build
```

## Chạy & phát triển

```bash
# Cài dependencies
flutter pub get

# Chạy app (dừng app cũ trước, tránh hot reload sau khi thêm plugin)
flutter run

# Phân tích & test
flutter analyze
flutter test

# Chạy trên desktop
flutter run -d macos
```

> **Lưu ý:** Nếu gặp lỗi `MissingPluginException` với `path_provider`, dừng app hoàn toàn và `flutter run` lại (không dùng hot reload). App đã đăng ký plugin trong `main()` và có fallback path.

## Màn hình hiện tại

- **Home** — welcome screen, điều hướng sang Items
- **Items** — thêm / xóa / xem danh sách item (persist qua SQLite)
- **Item Detail** — hiển thị chi tiết một record
- **Settings** — placeholder cho sprint tiếp theo

## Kế hoạch sprint

Chi tiết Sprint 1 (Core Router + SQLite): [`docs/plans/sprint-1-core-router-sqlite.md`](docs/plans/sprint-1-core-router-sqlite.md)

## Tài liệu tham khảo

- [ForUI docs](https://forui.dev/docs)
- [go_router](https://pub.dev/documentation/go_router/latest/)
- [Drift docs](https://drift.simonbinder.eu/docs/)
- [Riverpod](https://riverpod.dev/docs/introduction/getting_started)
