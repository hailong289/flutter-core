import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/items.dart';

part 'items_dao.g.dart';

@DriftAccessor(tables: [Items])
class ItemsDao extends DatabaseAccessor<AppDatabase> with _$ItemsDaoMixin {
  ItemsDao(super.db);

  Stream<List<Item>> watchAll() {
    return (select(items)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Future<Item?> getById(int id) {
    return (select(items)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertItem({
    required String title,
    String? description,
  }) {
    return into(items).insert(
      ItemsCompanion.insert(
        title: title,
        description: Value(description),
      ),
    );
  }

  Future<bool> updateItem({
    required int id,
    required String title,
    String? description,
  }) async {
    final updated = await (update(items)..where((t) => t.id.equals(id))).write(
      ItemsCompanion(
        title: Value(title),
        description: Value(description),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return updated > 0;
  }

  Future<int> deleteById(int id) {
    return (delete(items)..where((t) => t.id.equals(id))).go();
  }

  Future<int> count() async {
    final total = countAll();
    final query = selectOnly(items)..addColumns([total]);
    final row = await query.getSingle();
    return row.read(total) ?? 0;
  }

  Future<void> clearAll() => delete(items).go();
}
