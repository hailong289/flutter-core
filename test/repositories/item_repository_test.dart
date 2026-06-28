import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/core/database/app_database.dart';
import 'package:flutter_application_1/data/repositories/item_repository_impl.dart';

void main() {
  late AppDatabase db;
  late ItemRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = ItemRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('insert and watch items', () async {
    expect(await repository.watchAll().first, isEmpty);

    final id = await repository.create(title: 'Test item');
    expect(id, greaterThan(0));

    final items = await repository.watchAll().first;
    expect(items, hasLength(1));
    expect(items.first.title, 'Test item');
  });

  test('create with description', () async {
    await repository.create(
      title: 'With description',
      description: 'Details here',
    );

    final items = await repository.watchAll().first;
    expect(items.first.description, 'Details here');
  });

  test('getById returns item', () async {
    final id = await repository.create(title: 'Detail item');

    final item = await repository.getById(id);
    expect(item, isNotNull);
    expect(item!.title, 'Detail item');
  });

  test('update item', () async {
    final id = await repository.create(title: 'Old title');
    final item = (await repository.getById(id))!;

    await repository.update(
      item.copyWith(title: 'New title', description: 'Updated'),
    );

    final updated = await repository.getById(id);
    expect(updated!.title, 'New title');
    expect(updated.description, 'Updated');
  });

  test('delete removes item', () async {
    final id = await repository.create(title: 'To delete');
    await repository.delete(id);

    final items = await repository.watchAll().first;
    expect(items, isEmpty);
  });
}
