import 'package:shared_preferences/shared_preferences.dart';

enum PreferencesKeys { userToken }

class Preferences {
  static SharedPreferences? _instance;

  static Future<SharedPreferences?> _getInstance() async {
    _instance ??= await SharedPreferences.getInstance();

    return _instance;
  }

  static Future<Object?> get(PreferencesKeys key) async {
    return (await _getInstance())?.get(key.toString());
  }

  static Future<String?> getString(PreferencesKeys key) async {
    return (await _getInstance())?.getString(key.toString());
  }

  static Future<void> setString(PreferencesKeys key, String? value) async {
    (await _getInstance())?.setString(key.toString(), value ?? '');
  }

  static Future<void> clear() async => await (await _getInstance())?.clear();
}
