import 'shared_preferences_store.dart';

class OnboardingStorage {
  static const _key = 'has_seen_onboarding';

  static Future<bool> hasSeen() async {
    final prefs = await SharedPreferencesStore.instance();
    final value = await prefs.getBool(_key);
    return value ?? false;
  }

  static Future<void> markSeen() async {
    final prefs = await SharedPreferencesStore.instance();
    await prefs.setBool(_key, true);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferencesStore.instance();
    await prefs.remove(_key);
  }
}
