part of '../avatar_store_dialog.dart';

enum _AvatarStoreFilter { all, owned, unlockable }

const String _allRaritiesFilterValue = '__all_rarities__';

List<ProfileAvatarStoreItem> _buildVisibleAvatarItems({
  required List<ProfileAvatarStoreItem> avatarStore,
  required _AvatarStoreFilter activeFilter,
  required String activeRarity,
}) {
  final filtered =
      avatarStore
          .where(
            (item) => _matchesAvatarFilters(
              item,
              activeFilter: activeFilter,
              activeRarity: activeRarity,
            ),
          )
          .toList()
        ..sort((a, b) {
          final rankA = _avatarItemRank(a);
          final rankB = _avatarItemRank(b);
          if (rankA != rankB) {
            return rankA.compareTo(rankB);
          }

          final priceCompare = a.costHalfUnits.compareTo(b.costHalfUnits);
          if (priceCompare != 0) {
            return priceCompare;
          }

          return a.title.compareTo(b.title);
        });

  return filtered;
}

List<String> _collectAvailableAvatarRarities(
  List<ProfileAvatarStoreItem> avatarStore,
) {
  final rarities = <String>{};
  for (final item in avatarStore) {
    final normalized = item.rarity.trim().toLowerCase();
    if (normalized.isNotEmpty) {
      rarities.add(normalized);
    }
  }

  final values = rarities.toList()
    ..sort((a, b) {
      const order = <String, int>{
        'comum': 0,
        'raro': 1,
        'epico': 2,
        'lendario': 3,
      };
      final rankA = order[a] ?? 99;
      final rankB = order[b] ?? 99;
      if (rankA != rankB) {
        return rankA.compareTo(rankB);
      }
      return a.compareTo(b);
    });

  return values;
}

String _resolveNextSelectedSeed({
  required List<ProfileAvatarStoreItem> avatarStore,
  required String currentSelectedSeed,
  required _AvatarStoreFilter activeFilter,
  required String activeRarity,
}) {
  final nextVisible = _buildVisibleAvatarItems(
    avatarStore: avatarStore,
    activeFilter: activeFilter,
    activeRarity: activeRarity,
  );

  if (nextVisible.isEmpty ||
      nextVisible.any((item) => item.seed == currentSelectedSeed)) {
    return currentSelectedSeed;
  }

  return nextVisible.first.seed;
}

bool _matchesAvatarFilters(
  ProfileAvatarStoreItem item, {
  required _AvatarStoreFilter activeFilter,
  required String activeRarity,
}) {
  final matchesCategory = switch (activeFilter) {
    _AvatarStoreFilter.all => true,
    _AvatarStoreFilter.owned => item.owned || item.equipped,
    _AvatarStoreFilter.unlockable => !item.owned,
  };

  if (!matchesCategory) {
    return false;
  }

  if (activeRarity == _allRaritiesFilterValue) {
    return true;
  }

  return item.rarity.trim().toLowerCase() == activeRarity;
}

int _avatarItemRank(ProfileAvatarStoreItem item) {
  if (item.equipped) return 0;
  if (item.owned) return 1;
  if (item.affordable) return 2;
  return 3;
}

String _avatarPrimaryLabel(
  ProfileAvatarStoreItem? item, {
  required bool isSubmitting,
}) {
  if (isSubmitting) {
    return 'Salvando...';
  }
  if (item == null) {
    return 'Selecionar';
  }
  if (item.equipped) {
    return 'Em uso';
  }
  if (item.owned) {
    return 'Equipar agora';
  }
  if (item.affordable) {
    return 'Comprar';
  }
  return 'Sem saldo';
}

IconData _avatarPrimaryIcon(
  ProfileAvatarStoreItem? item, {
  required bool isSubmitting,
}) {
  if (isSubmitting) {
    return Icons.hourglass_top_rounded;
  }
  if (item == null) {
    return Icons.touch_app_rounded;
  }
  if (item.equipped) {
    return Icons.task_alt_rounded;
  }
  if (item.owned) {
    return Icons.check_circle_rounded;
  }
  if (item.affordable) {
    return Icons.shopping_bag_rounded;
  }
  return Icons.lock_rounded;
}

String _avatarSelectedDescription(ProfileAvatarStoreItem? item) {
  if (item == null) {
    return 'Escolha um avatar para personalizar seu perfil.';
  }

  final collectionLabel = item.theme.trim().isEmpty
      ? _formatAvatarRarity(item.rarity)
      : '${item.theme} · ${_formatAvatarRarity(item.rarity)}';

  if (item.equipped) {
    return '$collectionLabel. Esse avatar já esta equipado no seu perfil.';
  }
  if (item.owned) {
    return '$collectionLabel. Você já desbloqueou esse avatar. Toque para equipar.';
  }
  if (item.affordable) {
    return '$collectionLabel. Disponível para compra agora por ${formatCoinsLabel(item.costCoins)}.';
  }
  return '$collectionLabel. Junte mais moedas para desbloquear esse visual.';
}

String _avatarSelectedBadge(ProfileAvatarStoreItem? item) {
  if (item == null) {
    return 'Sem seleção';
  }
  if (item.equipped) {
    return 'Equipado';
  }
  if (item.owned) {
    return 'Adquirido';
  }
  if (item.affordable) {
    return 'Pronto para comprar';
  }
  return 'Bloqueado';
}

Color _avatarSelectedBadgeColor(ProfileAvatarStoreItem? item, Color primary) {
  if (item == null) {
    return const Color(0xFF8E96B8);
  }
  if (item.equipped) {
    return primary;
  }
  if (item.owned) {
    return const Color(0xFF26D078);
  }
  if (item.affordable) {
    return const Color(0xFFFFC857);
  }
  return const Color(0xFFFF8B7A);
}

Color _avatarPrimaryButtonColor(ProfileAvatarStoreItem? item) {
  if (item == null) {
    return const Color(0xFF5868D8);
  }
  if (item.equipped) {
    return const Color(0xFF5A6788);
  }
  if (item.owned) {
    return const Color(0xFF3F7B73);
  }
  if (item.affordable) {
    return const Color(0xFF5868D8);
  }
  return const Color(0xFF8B5F6B);
}

String _avatarPriceLabel(ProfileAvatarStoreItem item) {
  if (item.equipped) return 'Em uso';
  if (item.owned) return 'Comprado';
  if (item.costCoins <= 0) return 'Grátis';
  return formatCoinsLabel(item.costCoins);
}
