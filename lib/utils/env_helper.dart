import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Keys {
  SCRUMFLOW_API_URL;

  String get value => switch (this) {
        Keys.SCRUMFLOW_API_URL => 'SCRUMFLOW-API',
      };
}

class EnvHelper {
  static String getKey(Keys key) => dotenv.get(key.value, fallback: '');
}
