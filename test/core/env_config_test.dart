import 'package:flutter_application_1/core/config/env_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('EnvConfig.test factory', () {
    final config = EnvConfig.test(
      appEnv: 'staging',
      apiBaseUrl: 'https://staging.example.com',
      enableDebugLog: true,
    );

    expect(config.appEnv, 'staging');
    expect(config.apiBaseUrl, 'https://staging.example.com');
    expect(config.enableDebugLog, isTrue);
    expect(config.isProduction, isFalse);
    expect(config.isDevelopment, isFalse);
  });
}
