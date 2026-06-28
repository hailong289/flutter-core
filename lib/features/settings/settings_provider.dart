import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/database/database_path.dart';
import '../../providers/repository_providers.dart';

final packageInfoProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

final itemCountProvider = FutureProvider<int>((ref) {
  return ref.watch(itemRepositoryProvider).count();
});

final databasePathProvider = FutureProvider<String>((ref) {
  return resolveDatabaseFilePath();
});
