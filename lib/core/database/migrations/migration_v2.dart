import 'package:drift/drift.dart';

import 'migration_helpers.dart';

/// Idempotent v1 → v2: adds `description` and `updated_at` to `items`.
Future<void> migrateToV2(GeneratedDatabase db) async {
  final existing = await tableColumns(db, 'items');

  if (!existing.contains('description')) {
    await db.customStatement('ALTER TABLE items ADD COLUMN description TEXT');
  }
  if (!existing.contains('updated_at')) {
    await db.customStatement(
      'ALTER TABLE items ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0',
    );
    await db.customStatement('UPDATE items SET updated_at = created_at');
  }
}
