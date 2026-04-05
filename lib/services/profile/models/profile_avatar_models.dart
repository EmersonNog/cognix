class ProfileAvatarStoreItem {
  const ProfileAvatarStoreItem({
    required this.seed,
    required this.title,
    required this.theme,
    required this.rarity,
    required this.costCoins,
    required this.costHalfUnits,
    required this.owned,
    required this.equipped,
    required this.affordable,
    required this.isDefault,
  });

  final String seed;
  final String title;
  final String theme;
  final String rarity;
  final double costCoins;
  final int costHalfUnits;
  final bool owned;
  final bool equipped;
  final bool affordable;
  final bool isDefault;
}

class ProfileAvatarSelectionResult {
  const ProfileAvatarSelectionResult({
    required this.status,
    required this.action,
    required this.coinsBalance,
    required this.coinsHalfUnits,
    required this.equippedAvatarSeed,
    required this.ownedAvatarSeeds,
    required this.avatarStore,
    required this.requiredCoins,
    required this.missingCoins,
  });

  final String status;
  final String action;
  final double coinsBalance;
  final int coinsHalfUnits;
  final String equippedAvatarSeed;
  final List<String> ownedAvatarSeeds;
  final List<ProfileAvatarStoreItem> avatarStore;
  final double? requiredCoins;
  final double? missingCoins;

  bool get isSuccess => status == 'ok';
}
