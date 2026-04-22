import 'shared_preferences_store.dart';

class FlashcardsTutorialStorage {
  static const _seenKey = 'has_seen_flashcards_review_tutorial';
  static const _createdAnyKey = 'has_created_any_flashcard';
  static const _pendingTutorialKey = 'should_show_flashcards_review_tutorial';

  static Future<bool> hasSeen() async {
    final scopedKey = SharedPreferencesStore.resolveScopedKey(_seenKey);
    final prefs = await SharedPreferencesStore.instance();
    final value = await prefs.getBool(scopedKey.storageKey);

    if (value != null) return value;

    if (scopedKey.hasLegacyBaseKey) {
      final legacyValue = await prefs.getBool(scopedKey.baseKey);
      if (legacyValue != null) return legacyValue;
    }

    return false;
  }

  static Future<bool> shouldShowReviewTutorial() async {
    final scopedKey = SharedPreferencesStore.resolveScopedKey(_pendingTutorialKey);
    final prefs = await SharedPreferencesStore.instance();
    final value = await prefs.getBool(scopedKey.storageKey);

    if (value != null) return value;

    if (scopedKey.hasLegacyBaseKey) {
      final legacyValue = await prefs.getBool(scopedKey.baseKey);
      if (legacyValue != null) return legacyValue;
    }

    return false;
  }

  static Future<void> registerFlashcardCreation() async {
    final createdScopedKey = SharedPreferencesStore.resolveScopedKey(_createdAnyKey);
    final pendingScopedKey = SharedPreferencesStore.resolveScopedKey(
      _pendingTutorialKey,
    );
    final prefs = await SharedPreferencesStore.instance();
    final hasCreatedBefore = await prefs.getBool(createdScopedKey.storageKey);

    if (hasCreatedBefore != true) {
      await prefs.setBool(createdScopedKey.storageKey, true);
      await prefs.setBool(pendingScopedKey.storageKey, true);
    }
  }

  static Future<void> markSeen() async {
    final scopedKey = SharedPreferencesStore.resolveScopedKey(_seenKey);
    final pendingScopedKey = SharedPreferencesStore.resolveScopedKey(
      _pendingTutorialKey,
    );
    final prefs = await SharedPreferencesStore.instance();
    await prefs.setBool(scopedKey.storageKey, true);
    await prefs.setBool(pendingScopedKey.storageKey, false);

    if (scopedKey.hasLegacyBaseKey) {
      await prefs.remove(scopedKey.baseKey);
    }
    if (pendingScopedKey.hasLegacyBaseKey) {
      await prefs.remove(pendingScopedKey.baseKey);
    }
  }

  static Future<void> resetForDebug() async {
    final seenScopedKey = SharedPreferencesStore.resolveScopedKey(_seenKey);
    final createdScopedKey = SharedPreferencesStore.resolveScopedKey(_createdAnyKey);
    final pendingScopedKey = SharedPreferencesStore.resolveScopedKey(
      _pendingTutorialKey,
    );
    final prefs = await SharedPreferencesStore.instance();

    await prefs.setBool(createdScopedKey.storageKey, true);
    await prefs.setBool(seenScopedKey.storageKey, false);
    await prefs.setBool(pendingScopedKey.storageKey, true);

    if (seenScopedKey.hasLegacyBaseKey) {
      await prefs.remove(seenScopedKey.baseKey);
    }
    if (createdScopedKey.hasLegacyBaseKey) {
      await prefs.remove(createdScopedKey.baseKey);
    }
    if (pendingScopedKey.hasLegacyBaseKey) {
      await prefs.remove(pendingScopedKey.baseKey);
    }
  }
}
