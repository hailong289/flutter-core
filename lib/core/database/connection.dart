import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'database_path.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final dbFolder = await resolveDatabaseDirectory();
    if (Platform.isIOS || Platform.isMacOS) {
      sqlite3.tempDirectory = dbFolder.path;
    }
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    cacheDatabaseFilePath(file.path);
    if (kDebugMode) {
      debugPrint('Database path: ${file.path}');
    }
    return NativeDatabase.createInBackground(file);
  });
}
