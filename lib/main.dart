import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/platform/register_path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerPathProvider();
  runApp(const ProviderScope(child: Application()));
}
