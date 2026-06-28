import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/database/database_path.dart';
import '../../providers/database_provider.dart';
import 'settings_provider.dart';

Future<void> exportDatabaseFile() async {
  final path = await resolveDatabaseFilePath();
  final file = File(path);
  if (!await file.exists()) {
    throw StateError('Database file not found');
  }

  if (Platform.isAndroid || Platform.isIOS) {
    await Share.shareXFiles([XFile(path)], text: 'App database backup');
    return;
  }

  final outputPath = await FilePicker.platform.saveFile(
    fileName: 'app.sqlite',
    type: FileType.custom,
    allowedExtensions: ['sqlite', 'db'],
  );
  if (outputPath != null) {
    await file.copy(outputPath);
  }
}

Future<void> clearAllItems(WidgetRef ref) async {
  await ref.read(databaseProvider).itemsDao.clearAll();
  ref.invalidate(itemCountProvider);
}
