import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Object _useCurrentUserPreferenceScope = Object();

class ScopedPreferenceKey {
  const ScopedPreferenceKey({required this.baseKey, required this.storageKey});

  final String baseKey;
  final String storageKey;

  bool get hasLegacyBaseKey => storageKey != baseKey;
}

class SharedPreferencesStore {
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static Future<SharedPreferencesAsync> instance() async {
    return _prefs;
  }

  static ScopedPreferenceKey resolveScopedKey(
    String baseKey, {
    Object? userId = _useCurrentUserPreferenceScope,
  }) {
    final resolvedUserId = identical(userId, _useCurrentUserPreferenceScope)
        ? FirebaseAuth.instance.currentUser?.uid
        : userId as String?;
    final normalizedUserId = resolvedUserId?.trim();

    if (normalizedUserId == null || normalizedUserId.isEmpty) {
      return ScopedPreferenceKey(baseKey: baseKey, storageKey: baseKey);
    }

    return ScopedPreferenceKey(
      baseKey: baseKey,
      storageKey: '$baseKey::$normalizedUserId',
    );
  }
}
