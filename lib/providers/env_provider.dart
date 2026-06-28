import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/env_config.dart';
import '../core/config/env.dart';

final envProvider = Provider<EnvConfig>((ref) => readEnvConfig());
