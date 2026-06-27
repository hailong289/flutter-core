import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'database_path.dart';
import 'tables/items.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Items])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Item>> watchAllItems() {
    return (select(items)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<Item?> getItem(int id) {
    return (select(items)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertItem(String title) {
    return into(items).insert(
      ItemsCompanion.insert(title: title),
    );
  }

  Future<int> deleteItem(int id) {
    return (delete(items)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final dbFolder = await resolveDatabaseDirectory();
    if (Platform.isIOS || Platform.isMacOS) {
      sqlite3.tempDirectory = dbFolder.path;
    }
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    if (kDebugMode) {
      debugPrint('Database path: ${file.path}');
    }
    return NativeDatabase.createInBackground(file);
  });
}
