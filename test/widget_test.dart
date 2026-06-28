import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/core/config/env_config.dart';
import 'package:flutter_application_1/core/database/app_database.dart';
import 'package:flutter_application_1/core/preferences/app_preferences.dart';
import 'package:flutter_application_1/providers/database_provider.dart';
import 'package:flutter_application_1/providers/env_provider.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      AppPreferences.onboardingCompleted: true,
      AppPreferences.themeMode: 'dark',
    });
  });

  testWidgets('Application shows home screen', (WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          envProvider.overrideWithValue(EnvConfig.test()),
        ],
        child: const Application(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Core app with router, SQLite & settings'), findsOneWidget);
  });
}
