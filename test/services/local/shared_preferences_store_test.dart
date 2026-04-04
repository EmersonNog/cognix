import 'package:cognix/services/local/shared_preferences_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SharedPreferencesStore.resolveScopedKey', () {
    test('keeps the base key when there is no authenticated user id', () {
      final key = SharedPreferencesStore.resolveScopedKey(
        'training_session_state',
        userId: null,
      );

      expect(key.baseKey, 'training_session_state');
      expect(key.storageKey, 'training_session_state');
      expect(key.hasLegacyBaseKey, isFalse);
    });

    test('namespaces the key when a user id is available', () {
      final key = SharedPreferencesStore.resolveScopedKey(
        'selected_avatar_seed',
        userId: 'user-123',
      );

      expect(key.baseKey, 'selected_avatar_seed');
      expect(key.storageKey, 'selected_avatar_seed::user-123');
      expect(key.hasLegacyBaseKey, isTrue);
    });

    test('trims user ids before composing the storage key', () {
      final key = SharedPreferencesStore.resolveScopedKey(
        'selected_avatar_seed',
        userId: '  abc  ',
      );

      expect(key.storageKey, 'selected_avatar_seed::abc');
    });
  });
}
