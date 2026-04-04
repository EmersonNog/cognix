import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../services/profile/profile_api.dart';
import 'widgets/profile_header_utils.dart';

part 'avatar_store/formatters.dart';
part 'avatar_store/header_widgets.dart';
part 'avatar_store/spotlight_widgets.dart';
part 'avatar_store/catalog_widgets.dart';

enum _AvatarStoreFilter { all, owned, unlockable }

class AvatarSelectorDialog extends StatefulWidget {
  const AvatarSelectorDialog({
    super.key,
    required this.primary,
    required this.onSurface,
    required this.surfaceContainer,
    required this.coinsBalance,
    required this.equippedAvatarSeed,
    required this.avatarStore,
  });

  final Color primary;
  final Color onSurface;
  final Color surfaceContainer;
  final double coinsBalance;
  final String equippedAvatarSeed;
  final List<ProfileAvatarStoreItem> avatarStore;

  @override
  State<AvatarSelectorDialog> createState() => _AvatarSelectorDialogState();
}

class _AvatarSelectorDialogState extends State<AvatarSelectorDialog> {
  late String _selectedSeed;
  late double _coinsBalance;
  late List<ProfileAvatarStoreItem> _avatarStore;
  bool _isSubmitting = false;
  _AvatarStoreFilter _activeFilter = _AvatarStoreFilter.all;

  @override
  void initState() {
    super.initState();
    _selectedSeed = widget.equippedAvatarSeed.trim().isNotEmpty
        ? widget.equippedAvatarSeed
        : (widget.avatarStore.isNotEmpty
              ? widget.avatarStore.first.seed
              : 'avatar_1');
    _coinsBalance = widget.coinsBalance;
    _avatarStore = widget.avatarStore;
  }

  ProfileAvatarStoreItem? get _selectedItem {
    for (final item in _avatarStore) {
      if (item.seed == _selectedSeed) {
        return item;
      }
    }
    return null;
  }

  List<ProfileAvatarStoreItem> get _visibleItems {
    final filtered = _avatarStore.where((item) {
      switch (_activeFilter) {
        case _AvatarStoreFilter.all:
          return true;
        case _AvatarStoreFilter.owned:
          return item.owned || item.equipped;
        case _AvatarStoreFilter.unlockable:
          return !item.owned;
      }
    }).toList();

    filtered.sort((a, b) {
      final rankA = _itemRank(a);
      final rankB = _itemRank(b);
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

  bool get _canSubmit {
    final item = _selectedItem;
    if (_isSubmitting || item == null) {
      return false;
    }
    if (item.equipped) {
      return false;
    }
    return item.owned || item.affordable;
  }

  int _itemRank(ProfileAvatarStoreItem item) {
    if (item.equipped) return 0;
    if (item.owned) return 1;
    if (item.affordable) return 2;
    return 3;
  }

  void _changeFilter(_AvatarStoreFilter filter) {
    final nextVisible = _avatarStore.where((item) {
      switch (filter) {
        case _AvatarStoreFilter.all:
          return true;
        case _AvatarStoreFilter.owned:
          return item.owned || item.equipped;
        case _AvatarStoreFilter.unlockable:
          return !item.owned;
      }
    }).toList();

    setState(() {
      _activeFilter = filter;
      if (nextVisible.isNotEmpty &&
          !nextVisible.any((item) => item.seed == _selectedSeed)) {
        _selectedSeed = nextVisible.first.seed;
      }
    });
  }

  String _primaryLabel(ProfileAvatarStoreItem? item) {
    if (_isSubmitting) {
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
      return 'Comprar por ${formatCoinsLabel(item.costCoins)}';
    }
    return 'Sem saldo';
  }

  IconData _primaryIcon(ProfileAvatarStoreItem? item) {
    if (_isSubmitting) {
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

  String _selectedDescription(ProfileAvatarStoreItem? item) {
    if (item == null) {
      return 'Escolha um avatar para personalizar seu perfil.';
    }

    final collectionLabel = item.theme.trim().isEmpty
        ? _formatAvatarRarity(item.rarity)
        : '${item.theme} · ${_formatAvatarRarity(item.rarity)}';

    if (item.equipped) {
      return '$collectionLabel. Esse avatar ja esta equipado no seu perfil.';
    }
    if (item.owned) {
      return '$collectionLabel. Voce ja desbloqueou esse avatar. Toque para equipar.';
    }
    if (item.affordable) {
      return '$collectionLabel. Disponivel para compra agora por ${formatCoinsLabel(item.costCoins)}.';
    }
    return '$collectionLabel. Junte mais coins para desbloquear esse visual.';
  }

  String _selectedBadge(ProfileAvatarStoreItem? item) {
    if (item == null) {
      return 'Sem selecao';
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

  Color _selectedBadgeColor(ProfileAvatarStoreItem? item) {
    if (item == null) {
      return const Color(0xFF8E96B8);
    }
    if (item.equipped) {
      return widget.primary;
    }
    if (item.owned) {
      return const Color(0xFF26D078);
    }
    if (item.affordable) {
      return const Color(0xFFFFC857);
    }
    return const Color(0xFFFF8B7A);
  }

  Color _primaryButtonColor(ProfileAvatarStoreItem? item) {
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

  String _priceLabel(ProfileAvatarStoreItem item) {
    if (item.equipped) return 'Em uso';
    if (item.owned) return 'Comprado';
    if (item.costCoins <= 0) return 'Gratis';
    return formatCoinsLabel(item.costCoins);
  }

  Future<void> _submitSelection() async {
    final item = _selectedItem;
    if (!_canSubmit || item == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await selectProfileAvatar(item.seed);
      if (!mounted) return;

      if (result.isSuccess) {
        Navigator.pop(context, true);
        return;
      }

      setState(() {
        _coinsBalance = result.coinsBalance;
        _avatarStore = result.avatarStore;
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = _selectedItem;
    final visibleItems = _visibleItems;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.8;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 520, maxHeight: maxHeight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: const Color(0xFF10192F),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 28,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Column(
              children: <Widget>[
                _AvatarShopHero(
                  title: 'Avatares do perfil',
                  subtitle:
                      'Escolha um visual para representar seu momento e equipe sem sair do painel.',
                  balanceLabel: formatCoinsLabel(_coinsBalance),
                  badgeLabel: _selectedBadge(selectedItem),
                  badgeColor: _selectedBadgeColor(selectedItem),
                  primary: widget.primary,
                  onSurface: widget.onSurface,
                  onClose: _isSubmitting ? null : () => Navigator.pop(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _AvatarSpotlightCard(
                          item: selectedItem,
                          priceLabel: selectedItem == null
                              ? null
                              : _priceLabel(selectedItem),
                          rarityLabel: selectedItem == null
                              ? null
                              : _formatAvatarRarity(selectedItem.rarity),
                          themeLabel: selectedItem?.theme,
                          rarityColor: selectedItem == null
                              ? widget.primary
                              : _avatarRarityColor(
                                  selectedItem.rarity,
                                  widget.primary,
                                ),
                          description: _selectedDescription(selectedItem),
                          primary: widget.primary,
                          onSurface: widget.onSurface,
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: <Widget>[
                            _AvatarFilterChip(
                              label: 'Todos',
                              selected: _activeFilter == _AvatarStoreFilter.all,
                              primary: widget.primary,
                              onSurface: widget.onSurface,
                              onTap: () =>
                                  _changeFilter(_AvatarStoreFilter.all),
                            ),
                            _AvatarFilterChip(
                              label: 'Meus',
                              selected:
                                  _activeFilter == _AvatarStoreFilter.owned,
                              primary: widget.primary,
                              onSurface: widget.onSurface,
                              onTap: () =>
                                  _changeFilter(_AvatarStoreFilter.owned),
                            ),
                            _AvatarFilterChip(
                              label: 'Para comprar',
                              selected:
                                  _activeFilter ==
                                  _AvatarStoreFilter.unlockable,
                              primary: widget.primary,
                              onSurface: widget.onSurface,
                              onTap: () =>
                                  _changeFilter(_AvatarStoreFilter.unlockable),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        if (visibleItems.isEmpty)
                          _AvatarEmptyState(onSurface: widget.onSurface)
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: visibleItems.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  childAspectRatio: 0.82,
                                ),
                            itemBuilder: (context, index) {
                              final item = visibleItems[index];
                              return _AvatarStoreTile(
                                item: item,
                                isSelected: _selectedSeed == item.seed,
                                primary: widget.primary,
                                onSurface: widget.onSurface,
                                onTap: () {
                                  setState(() {
                                    _selectedSeed = item.seed;
                                  });
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141E39),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSubmitting
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: widget.onSurface,
                            backgroundColor: const Color(0xFF18223D),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.14),
                            ),
                            minimumSize: const Size.fromHeight(50),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: widget.onSurface.withValues(alpha: 0.92),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Fechar',
                                style: GoogleFonts.manrope(
                                  color: widget.onSurface.withValues(alpha: 0.94),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _canSubmit ? _submitSelection : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryButtonColor(selectedItem),
                            disabledBackgroundColor: _primaryButtonColor(
                              selectedItem,
                            ).withValues(alpha: 0.55),
                            elevation: 0,
                            minimumSize: const Size.fromHeight(50),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                _primaryIcon(selectedItem),
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _primaryLabel(selectedItem),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.manrope(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
