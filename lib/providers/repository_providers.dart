import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import 'database_provider.dart';

class ItemRepository {
  ItemRepository(this._db);

  final AppDatabase _db;

  Stream<List<Item>> watchAll() => _db.watchAllItems();

  Future<Item?> getById(int id) => _db.getItem(id);

  Future<int> insert(String title) => _db.insertItem(title);

  Future<void> delete(int id) => _db.deleteItem(id);
}

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return ItemRepository(ref.watch(databaseProvider));
});
