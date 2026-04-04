import 'package:firebase_auth/firebase_auth.dart';

import 'shared_preferences_store.dart';

class AvatarService {
  static const String _avatarSeedBaseKey = 'selected_avatar_seed';

  static Future<void> saveAvatarSeed(String seed) async {
    final prefs = await SharedPreferencesStore.instance();
    final key = SharedPreferencesStore.resolveScopedKey(_avatarSeedBaseKey);
    await prefs.setString(key.storageKey, seed);
    if (key.hasLegacyBaseKey) {
      await prefs.remove(key.baseKey);
    }
  }

  static Future<String?> getAvatarSeed() async {
    final prefs = await SharedPreferencesStore.instance();
    final key = SharedPreferencesStore.resolveScopedKey(_avatarSeedBaseKey);
    final seed = await prefs.getString(key.storageKey);
    if (key.hasLegacyBaseKey) {
      await prefs.remove(key.baseKey);
    }
    return seed;
  }

  static Future<void> clearAvatarSeed() async {
    final prefs = await SharedPreferencesStore.instance();
    final key = SharedPreferencesStore.resolveScopedKey(_avatarSeedBaseKey);
    await prefs.remove(key.storageKey);
    if (key.hasLegacyBaseKey) {
      await prefs.remove(key.baseKey);
    }
  }

  static String defaultAvatarSeed({String? fallback}) {
    final user = FirebaseAuth.instance.currentUser;
    final candidates = [user?.uid, user?.email, user?.displayName, fallback];

    for (final candidate in candidates) {
      final normalized = candidate?.trim();
      if (normalized != null && normalized.isNotEmpty) {
        return normalized;
      }
    }

    return 'cognix_default_avatar';
  }
}
