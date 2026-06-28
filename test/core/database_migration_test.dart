import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

import 'package:flutter_application_1/core/database/app_database.dart';

void main() {
  test('migrates schema v1 to v2', () async {
    final sqliteDb = sqlite3.openInMemory()
      ..execute(
        'CREATE TABLE items ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'title TEXT NOT NULL CHECK(length(title) BETWEEN 1 AND 200), '
        'created_at INTEGER NOT NULL DEFAULT (CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER))'
        ')',
      )
      ..execute("INSERT INTO items (title) VALUES ('legacy item')")
      ..execute('PRAGMA user_version = 1');

    final db = AppDatabase(NativeDatabase.opened(sqliteDb));
    addTearDown(db.close);

    final item = await db.itemsDao.getById(1);
    expect(item, isNotNull);
    expect(item!.title, 'legacy item');
    expect(item.description, isNull);
    expect(item.updatedAt, item.createdAt);
  });

  test('resumes partial v1 to v2 migration when description already exists', () async {
    final sqliteDb = sqlite3.openInMemory()
      ..execute(
        'CREATE TABLE items ('
        'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'title TEXT NOT NULL CHECK(length(title) BETWEEN 1 AND 200), '
        'created_at INTEGER NOT NULL DEFAULT (CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)), '
        'description TEXT'
        ')',
      )
      ..execute("INSERT INTO items (title) VALUES ('legacy item')")
      ..execute('PRAGMA user_version = 1');

    final db = AppDatabase(NativeDatabase.opened(sqliteDb));
    addTearDown(db.close);

    final item = await db.itemsDao.getById(1);
    expect(item, isNotNull);
    expect(item!.description, isNull);
    expect(item.updatedAt, item.createdAt);
  });
}
