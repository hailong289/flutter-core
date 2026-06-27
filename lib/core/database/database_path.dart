import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Resolves a persistent directory for the SQLite database file.
Future<Directory> resolveDatabaseDirectory() async {
  try {
    return await getApplicationDocumentsDirectory();
  } on MissingPluginException catch (error) {
    if (kDebugMode) {
      debugPrint(
        'path_provider unavailable ($error), using fallback database path.',
      );
    }
    return _fallbackDatabaseDirectory();
  }
}

Directory _fallbackDatabaseDirectory() {
  if (Platform.isMacOS || Platform.isIOS) {
    final home = Platform.environment['HOME'];
    if (home != null) {
      final dir = Directory(
        p.join(home, 'Library', 'Application Support', 'flutter_application_1'),
      );
      dir.createSync(recursive: true);
      return dir;
    }
  }

  if (Platform.isLinux) {
    final home = Platform.environment['HOME'];
    if (home != null) {
      final dir = Directory(
        p.join(home, '.local', 'share', 'flutter_application_1'),
      );
      dir.createSync(recursive: true);
      return dir;
    }
  }

  if (Platform.isWindows) {
    final appData = Platform.environment['APPDATA'];
    if (appData != null) {
      final dir = Directory(p.join(appData, 'flutter_application_1'));
      dir.createSync(recursive: true);
      return dir;
    }
  }

  final dir = Directory(
    p.join(Directory.systemTemp.path, 'flutter_application_1'),
  );
  dir.createSync(recursive: true);
  return dir;
}
