import 'dart:io';

import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_foundation/path_provider_foundation.dart';
import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:path_provider_windows/path_provider_windows.dart';

/// Registers path_provider platform implementations.
///
/// Required because path_provider 2.x uses Dart/FFI plugins that may not be
/// registered after hot reload or when the generated registrant was not run.
void registerPathProvider() {
  if (Platform.isAndroid) {
    PathProviderAndroid.registerWith();
  } else if (Platform.isIOS || Platform.isMacOS) {
    PathProviderFoundation.registerWith();
  } else if (Platform.isLinux) {
    PathProviderLinux.registerWith();
  } else if (Platform.isWindows) {
    PathProviderWindows.registerWith();
  }
}
