import 'package:drift/drift.dart';

import '../app_database.dart';
import '../schema_version.dart';
import 'migration_v2.dart';

/// Registers and runs schema upgrades in order.
///
/// When adding v3: create `migration_v3.dart`, add `if (from < 3)` below,
/// and bump [kSchemaVersion].
class AppMigrations {
  static MigrationStrategy forDatabase(AppDatabase db) => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, from, to) => runUpgrades(db, from, to),
  );

  static Future<void> runUpgrades(
    AppDatabase db,
    int from,
    int to,
  ) async {
    assert(from <= to && to <= kSchemaVersion);

    if (from < 2) {
      await migrateToV2(db);
    }
    // if (from < 3) await migrateToV3(db);
  }
}
