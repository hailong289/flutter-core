import '../entities/item.dart';

abstract class ItemRepository {
  Stream<List<Item>> watchAll();

  Future<Item?> getById(int id);

  Future<int> create({required String title, String? description});

  Future<void> update(Item item);

  Future<void> delete(int id);

  Future<int> count();
}
