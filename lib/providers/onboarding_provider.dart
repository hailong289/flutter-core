import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/preferences/app_preferences.dart';
import 'shared_preferences_provider.dart';

class OnboardingNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getBool(AppPreferences.onboardingCompleted) ?? false;
  }

  Future<void> complete() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setBool(AppPreferences.onboardingCompleted, true);
    state = const AsyncData(true);
  }
}

final onboardingProvider = AsyncNotifierProvider<OnboardingNotifier, bool>(
  OnboardingNotifier.new,
);
