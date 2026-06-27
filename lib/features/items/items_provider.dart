import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../providers/repository_providers.dart';

final itemsStreamProvider = StreamProvider<List<Item>>((ref) {
  return ref.watch(itemRepositoryProvider).watchAll();
});

final itemProvider = FutureProvider.family<Item?, int>((ref, id) {
  return ref.watch(itemRepositoryProvider).getById(id);
});
