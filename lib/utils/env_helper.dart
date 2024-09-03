import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Keys { SCRUMFLOW_API_URL }

class EnvHelper {
  static String getKey(Keys key) => DotEnv().get(key.name, fallback: '');
}
