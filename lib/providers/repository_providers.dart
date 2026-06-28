import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/item_repository_impl.dart';
import '../domain/repositories/item_repository.dart';
import 'database_provider.dart';

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return ItemRepositoryImpl(ref.watch(databaseProvider));
});
