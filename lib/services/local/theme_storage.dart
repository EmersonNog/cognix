import 'shared_preferences_store.dart';

class ThemeStorage {
  static const _key = 'app_theme_preference';

  static Future<String?> readPreference() async {
    final prefs = await SharedPreferencesStore.instance();
    return prefs.getString(_key);
  }

  static Future<void> savePreference(String value) async {
    final prefs = await SharedPreferencesStore.instance();
    await prefs.setString(_key, value);
  }
}
