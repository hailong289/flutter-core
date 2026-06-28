import 'package:drift/drift.dart';

import 'connection.dart';
import 'daos/items_dao.dart';
import 'migrations/app_migrations.dart';
import 'schema_version.dart';
import 'tables/items.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Items], daos: [ItemsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  @override
  int get schemaVersion => kSchemaVersion;

  @override
  MigrationStrategy get migration => AppMigrations.forDatabase(this);
}
