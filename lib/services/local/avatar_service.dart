import 'shared_preferences_store.dart';

class AvatarService {
  static const String _avatarSeedKey = 'selected_avatar_seed';

  static Future<void> saveAvatarSeed(String seed) async {
    final prefs = await SharedPreferencesStore.instance();
    await prefs.setString(_avatarSeedKey, seed);
  }

  static Future<String?> getAvatarSeed() async {
    final prefs = await SharedPreferencesStore.instance();
    return prefs.getString(_avatarSeedKey);
  }

  static Future<void> clearAvatarSeed() async {
    final prefs = await SharedPreferencesStore.instance();
    await prefs.remove(_avatarSeedKey);
  }
}
