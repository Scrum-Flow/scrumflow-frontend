import 'package:shared_preferences/shared_preferences.dart';

enum PrefsKeys { userToken }

class Prefs {
  static SharedPreferences? _instance;

  static Future<SharedPreferences?> _getInstance() async {
    _instance ??= await SharedPreferences.getInstance();

    return _instance;
  }

  static Future<Object?> get(PrefsKeys key) async {
    return (await _getInstance())?.get(key.toString());
  }

  static Future<String?> getString(PrefsKeys key) async {
    return (await _getInstance())?.getString(key.toString());
  }

  static Future<void> setString(PrefsKeys key, String? value) async {
    (await _getInstance())?.setString(key.toString(), value ?? '');
  }

  static Future<void> clear() async => await (await _getInstance())?.clear();
}
