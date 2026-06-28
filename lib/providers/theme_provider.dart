import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../core/preferences/app_preferences.dart';
import 'shared_preferences_provider.dart';

enum AppThemeMode { system, light, dark }

class ThemeModeNotifier extends AsyncNotifier<AppThemeMode> {
  @override
  Future<AppThemeMode> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final raw = prefs.getString(AppPreferences.themeMode) ?? AppThemeMode.dark.name;
    return AppThemeMode.values.byName(raw);
  }

  Future<void> setMode(AppThemeMode mode) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(AppPreferences.themeMode, mode.name);
    state = AsyncData(mode);
  }
}

final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, AppThemeMode>(
      ThemeModeNotifier.new,
    );

FThemeData resolveFThemeData({
  required AppThemeMode mode,
  required bool touch,
}) {
  final isDark = switch (mode) {
    AppThemeMode.light => false,
    AppThemeMode.dark => true,
    AppThemeMode.system =>
      PlatformDispatcher.instance.platformBrightness == Brightness.dark,
  };

  final palette = isDark ? FThemes.neutral.dark : FThemes.neutral.light;
  return touch ? palette.touch : palette.desktop;
}

final fThemeDataProvider = Provider<FThemeData>((ref) {
  final mode = ref.watch(themeModeProvider).value ?? AppThemeMode.dark;
  final touch = const <TargetPlatform>{
    .android,
    .iOS,
    .fuchsia,
  }.contains(defaultTargetPlatform);
  return resolveFThemeData(mode: mode, touch: touch);
});
