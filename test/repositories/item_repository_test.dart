import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/core/database/app_database.dart';
import 'package:flutter_application_1/providers/repository_providers.dart';

void main() {
  late AppDatabase db;
  late ItemRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = ItemRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('insert and watch items', () async {
    expect(await repository.watchAll().first, isEmpty);

    final id = await repository.insert('Test item');
    expect(id, greaterThan(0));

    final items = await repository.watchAll().first;
    expect(items, hasLength(1));
    expect(items.first.title, 'Test item');
  });

  test('getById returns item', () async {
    final id = await repository.insert('Detail item');

    final item = await repository.getById(id);
    expect(item, isNotNull);
    expect(item!.title, 'Detail item');
  });

  test('delete removes item', () async {
    final id = await repository.insert('To delete');
    await repository.delete(id);

    final items = await repository.watchAll().first;
    expect(items, isEmpty);
  });
}
