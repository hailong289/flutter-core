import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  const EnvConfig({
    required this.appEnv,
    required this.apiBaseUrl,
    required this.enableDebugLog,
  });

  final String appEnv;
  final String apiBaseUrl;
  final bool enableDebugLog;

  factory EnvConfig.fromDotenv() {
    final env = dotenv.env;
    return EnvConfig(
      appEnv: env['APP_ENV'] ?? 'development',
      apiBaseUrl: env['API_BASE_URL'] ?? '',
      enableDebugLog: env['ENABLE_DEBUG_LOG'] == 'true',
    );
  }

  factory EnvConfig.test({
    String appEnv = 'development',
    String apiBaseUrl = 'https://api.example.com',
    bool enableDebugLog = false,
  }) {
    return EnvConfig(
      appEnv: appEnv,
      apiBaseUrl: apiBaseUrl,
      enableDebugLog: enableDebugLog,
    );
  }

  bool get isProduction => appEnv == 'production';
  bool get isDevelopment => appEnv == 'development';
}
