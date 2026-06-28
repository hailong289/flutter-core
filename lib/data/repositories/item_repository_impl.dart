import '../../core/database/app_database.dart' as db;
import '../../domain/entities/item.dart';
import '../../domain/repositories/item_repository.dart';

class ItemRepositoryImpl implements ItemRepository {
  ItemRepositoryImpl(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Item>> watchAll() {
    return _database.itemsDao.watchAll().map(
      (rows) => rows.map(_mapRow).toList(),
    );
  }

  @override
  Future<Item?> getById(int id) async {
    final row = await _database.itemsDao.getById(id);
    return row == null ? null : _mapRow(row);
  }

  @override
  Future<int> create({required String title, String? description}) {
    return _database.itemsDao.insertItem(
      title: title,
      description: description,
    );
  }

  @override
  Future<void> update(Item item) {
    return _database.itemsDao.updateItem(
      id: item.id,
      title: item.title,
      description: item.description,
    );
  }

  @override
  Future<void> delete(int id) => _database.itemsDao.deleteById(id);

  @override
  Future<int> count() => _database.itemsDao.count();

  Item _mapRow(db.Item row) {
    return Item(
      id: row.id,
      title: row.title,
      description: row.description,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
