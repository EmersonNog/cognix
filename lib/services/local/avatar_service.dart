import 'package:shared_preferences/shared_preferences.dart';

class AvatarService {
  static const String _avatarSeedKey = 'selected_avatar_seed';

  static Future<void> saveAvatarSeed(String seed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarSeedKey, seed);
  }

  static Future<String?> getAvatarSeed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarSeedKey);
  }

  static Future<void> clearAvatarSeed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_avatarSeedKey);
  }
}
