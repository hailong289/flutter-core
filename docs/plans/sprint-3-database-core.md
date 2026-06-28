# Sprint 3 — Database Core (multi-table)

**Trạng thái:** Đang triển khai (core refactor hoàn thành)  
**Phụ thuộc:** Sprint 1 (Drift + router), Sprint 2 (domain + migration v2)

## Vấn đề

Trước Sprint 3, toàn bộ logic DB nằm trong một file `app_database.dart`:

- Định nghĩa `@DriftDatabase`
- Migration v1 → v2
- Mở connection SQLite
- Tất cả query CRUD cho bảng `items`

Khi thêm nhiều bảng (users, categories, tags, …), file này phình to, khó review và dễ conflict khi nhiều người làm song song.

## Mục tiêu

Tách **core database** thành các lớp rõ ràng, mỗi bảng / migration / connection một chỗ — dễ mở rộng mà không sửa file trung tâm.

## Kiến trúc mới

```
lib/core/database/
├── app_database.dart          # Chỉ @DriftDatabase + schemaVersion + migration
├── app_database.g.dart        # Generated (tables + DAO accessors)
├── connection.dart            # openConnection() — LazyDatabase + path
├── database_path.dart           # resolve path, cache path
├── schema_version.dart        # kSchemaVersion = 2
├── tables/
│   ├── tables.dart            # Barrel export
│   └── items.dart             # 1 file / bảng
├── daos/
│   ├── daos.dart              # Barrel export
│   └── items_dao.dart         # Query CRUD cho items
└── migrations/
    ├── app_migrations.dart    # MigrationStrategy + runUpgrades()
    ├── migration_helpers.dart # tableColumns(), tableHasColumn()
    └── migration_v2.dart      # migrateToV2() — idempotent
```

### Luồng dữ liệu

```
Feature UI
    ↓ Riverpod
Repository (domain interface)
    ↓
RepositoryImpl → AppDatabase.itemsDao (hoặc dao khác)
    ↓
Drift / SQLite
```

`AppDatabase` **không** chứa query nghiệp vụ — chỉ đăng ký tables, daos, và migration.

## Quy ước thêm bảng mới

Ví dụ thêm bảng `categories`:

### 1. Table — `tables/categories.dart`

```dart
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
}
```

### 2. DAO — `daos/categories_dao.dart`

```dart
@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);
  // watchAll(), getById(), insert, update, delete...
}
```

### 3. Đăng ký — `app_database.dart`

```dart
@DriftDatabase(
  tables: [Items, Categories],
  daos: [ItemsDao, CategoriesDao],
)
```

### 4. Migration (nếu schema đổi) — `migrations/migration_v3.dart`

```dart
Future<void> migrateToV3(GeneratedDatabase db) async { ... }
```

Trong `app_migrations.dart`:

```dart
if (from < 3) await migrateToV3(db);
```

Bump `kSchemaVersion` trong `schema_version.dart`.

### 5. Domain + Data

- `lib/domain/entities/category.dart`
- `lib/domain/repositories/category_repository.dart`
- `lib/data/repositories/category_repository_impl.dart` → dùng `db.categoriesDao`
- Provider trong `lib/providers/repository_providers.dart`

### 6. Codegen

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Migration — best practices

| Quy tắc | Lý do |
|---------|-------|
| Một file / phiên bản (`migration_v2.dart`, `migration_v3.dart`) | Dễ trace lịch sử schema |
| Idempotent (check `pragma_table_info` trước `ADD COLUMN`) | An toàn khi migration bị gián đoạn |
| Không dùng `DEFAULT CURRENT_TIMESTAMP` trong `ALTER TABLE` | SQLite hạn chế — dùng `DEFAULT 0` + `UPDATE` |
| `kSchemaVersion` tập trung một chỗ | Tránh lệch version giữa file |

## Đã hoàn thành (core refactor)

- [x] Tách `connection.dart`
- [x] Tách `schema_version.dart`
- [x] Tách `migrations/` (helpers, v2, orchestrator)
- [x] Tách `ItemsDao` — toàn bộ query items
- [x] `AppDatabase` gọn (~20 dòng)
- [x] `ItemRepositoryImpl` → `itemsDao`
- [x] Settings clear data → `itemsDao.clearAll()`
- [x] Tests migration cập nhật

## Sprint 3 — phần còn lại (tùy feature app)

- [ ] Bảng domain thật (thay hoặc bổ sung `items`)
- [ ] DAO + repository cho bảng mới
- [ ] Search / filter / sort qua DAO
- [ ] Import DB (restore từ export)
- [ ] Integration test multi-table (FK, cascade)

## Tiêu chí hoàn thành

- [x] Mỗi bảng: 1 file table + 1 DAO riêng
- [x] Migration tách file, có orchestrator
- [x] `AppDatabase` không chứa business query
- [x] `flutter analyze` + `flutter test` pass
- [ ] Ít nhất 1 bảng mới ngoài `items` (khi có feature)

## Tham chiếu

- [Drift — Table classes](https://drift.simonbinder.eu/docs/getting-started/)
- [Drift — DAOs](https://drift.simonbinder.eu/docs/advanced-features/daos/)
- [Drift — Migrations](https://drift.simonbinder.eu/docs/migrations/)
