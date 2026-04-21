part of '../parsers.dart';

ProfileAvatarSelectionResult parseProfileAvatarSelectionResult(
  Map<String, dynamic> payload,
) {
  final status = parseTrimmedString(payload['status'], fallback: 'error');
  final action = parseTrimmedString(payload['action'], fallback: status);
  final coinsBalance = parseDoubleValue(payload['coins_balance']);
  final coinsHalfUnits = parseIntValue(
    payload['coins_half_units'],
    fallback: (coinsBalance * 2).round(),
  );
  final equippedAvatarSeed = parseTrimmedString(
    payload['equipped_avatar_seed'],
    fallback: 'avatar_1',
  );

  return ProfileAvatarSelectionResult(
    status: status,
    action: action,
    coinsBalance: coinsBalance,
    coinsHalfUnits: coinsHalfUnits,
    equippedAvatarSeed: equippedAvatarSeed,
    ownedAvatarSeeds: parseOwnedAvatarSeeds(payload['owned_avatar_seeds']),
    avatarStore: parseProfileAvatarStoreItems(payload['avatar_store']),
    requiredCoins: _parseOptionalDouble(payload['required_coins']),
    missingCoins: _parseOptionalDouble(payload['missing_coins']),
  );
}

List<String> parseOwnedAvatarSeeds(dynamic raw) {
  if (raw is! List) {
    return const [];
  }

  return raw
      .map((item) => item?.toString().trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();
}

List<ProfileAvatarStoreItem> parseProfileAvatarStoreItems(dynamic raw) {
  if (raw is! List) {
    return const [];
  }

  return raw
      .whereType<Map>()
      .map((item) {
        return ProfileAvatarStoreItem(
          seed: parseTrimmedString(item['seed']),
          title: parseTrimmedString(item['title']),
          theme: parseTrimmedString(item['theme']),
          rarity: parseTrimmedString(item['rarity'], fallback: 'comum'),
          costCoins: parseDoubleValue(item['cost_coins']),
          costHalfUnits: parseIntValue(item['cost_half_units']),
          owned: item['owned'] == true,
          equipped: item['equipped'] == true,
          affordable: item['affordable'] == true,
          isDefault: item['is_default'] == true,
        );
      })
      .where((item) => item.seed.trim().isNotEmpty)
      .toList();
}

double? _parseOptionalDouble(Object? rawValue) {
  final normalized = '$rawValue';
  return normalized == 'null' ? null : double.tryParse(normalized);
}
