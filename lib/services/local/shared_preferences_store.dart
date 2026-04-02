import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStore {
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static Future<SharedPreferencesAsync> instance() async {
    return _prefs;
  }
}
