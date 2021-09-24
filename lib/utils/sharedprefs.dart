import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static saveStr(String key, String message) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, message);
  }

  static saveBool(String key, bool message) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, message);
  }

  static saveInt(String key, int message) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(key, message);
  }

  static readPrefStr(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getString(key);
  }

  static readPrefBool(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key);
  }

  static readPrefInt(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key);
  }

  static deletePrefs(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(key);
  }
}
