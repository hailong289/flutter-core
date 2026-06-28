import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'env_config.dart';

const _fallbackEnv = '''
APP_ENV=development
API_BASE_URL=https://api.example.com
ENABLE_DEBUG_LOG=false
''';

Future<void> loadEnv() async {
  try {
    await dotenv.load(fileName: '.env');
  } on Object {
    dotenv.testLoad(fileInput: _fallbackEnv);
  }
}

EnvConfig readEnvConfig() => EnvConfig.fromDotenv();
