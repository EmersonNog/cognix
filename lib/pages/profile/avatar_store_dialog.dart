import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../services/profile/profile_api.dart';
import '../../theme/cognix_theme_colors.dart';
import 'widgets/profile_header_utils.dart';

part 'avatar_store/dialog_logic.dart';
part 'avatar_store/formatters.dart';
part 'avatar_store/header_widgets.dart';
part 'avatar_store/spotlight_widgets.dart';
part 'avatar_store/catalog_widgets.dart';
part 'avatar_store/catalog_widgets/empty_state.dart';
part 'avatar_store/catalog_widgets/rarity_dropdown.dart';
part 'avatar_store/catalog_widgets/store_tile.dart';
part 'avatar_store/footer_widgets.dart';

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
  String _activeRarity = _allRaritiesFilterValue;

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

  List<ProfileAvatarStoreItem> get _visibleItems => _buildVisibleAvatarItems(
    avatarStore: _avatarStore,
    activeFilter: _activeFilter,
    activeRarity: _activeRarity,
  );

  List<String> get _availableRarities =>
      _collectAvailableAvatarRarities(_avatarStore);

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

  void _changeFilter(_AvatarStoreFilter filter) {
    final nextSelectedSeed = _resolveNextSelectedSeed(
      avatarStore: _avatarStore,
      currentSelectedSeed: _selectedSeed,
      activeFilter: filter,
      activeRarity: _activeRarity,
    );

    setState(() {
      _activeFilter = filter;
      _selectedSeed = nextSelectedSeed;
    });
  }

  void _changeRarity(String rarity) {
    final nextSelectedSeed = _resolveNextSelectedSeed(
      avatarStore: _avatarStore,
      currentSelectedSeed: _selectedSeed,
      activeFilter: _activeFilter,
      activeRarity: rarity,
    );

    setState(() {
      _activeRarity = rarity;
      _selectedSeed = nextSelectedSeed;
    });
  }

  Future<void> _submitSelection() async {
    final item = _selectedItem;
    if (!_canSubmit || item == null) {
      return;
    }

    setState(() => _isSubmitting = true);

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
    final palette = _AvatarStorePalette.fromContext(context);
    final selectedItem = _selectedItem;
    final visibleItems = _visibleItems;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.8;

    final selectedBadge = _avatarSelectedBadge(selectedItem);
    final selectedBadgeColor = _avatarSelectedBadgeColor(
      selectedItem,
      widget.primary,
    );
    final spotlightDescription = _avatarSelectedDescription(selectedItem);
    final primaryButtonLabel = _avatarPrimaryLabel(
      selectedItem,
      isSubmitting: _isSubmitting,
    );
    final primaryButtonIcon = _avatarPrimaryIcon(
      selectedItem,
      isSubmitting: _isSubmitting,
    );
    final primaryButtonColor = _avatarPrimaryButtonColor(selectedItem);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 520, maxHeight: maxHeight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                palette.border,
                palette.surfaceContainerHigh,
                palette.surfaceContainer,
              ],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.shadow,
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: widget.primary.withValues(alpha: 0.08),
                blurRadius: 26,
                spreadRadius: -8,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(1.1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
              color: palette.surfaceContainer,
              border: Border.all(color: palette.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: Column(
                children: <Widget>[
                  _AvatarShopHero(
                    title: 'Avatares do perfil',
                    subtitle: 'Escolha um visual para seu perfil.',
                    balanceLabel: formatCoinsLabel(_coinsBalance),
                    badgeLabel: selectedBadge,
                    badgeColor: selectedBadgeColor,
                    item: selectedItem,
                    priceLabel: selectedItem == null
                        ? null
                        : _avatarPriceLabel(selectedItem),
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
                    palette: palette,
                    description: spotlightDescription,
                    primary: widget.primary,
                    onSurface: widget.onSurface,
                    onClose: _isSubmitting
                        ? null
                        : () => Navigator.pop(context),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    decoration: BoxDecoration(
                      color: palette.surfaceContainer,
                      border: Border(bottom: BorderSide(color: palette.border)),
                    ),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _AvatarFilterChip(
                          label: 'Todos',
                          selected: _activeFilter == _AvatarStoreFilter.all,
                          primary: widget.primary,
                          onSurface: widget.onSurface,
                          palette: palette,
                          onTap: () => _changeFilter(_AvatarStoreFilter.all),
                        ),
                        _AvatarFilterChip(
                          label: 'Meus',
                          selected: _activeFilter == _AvatarStoreFilter.owned,
                          primary: widget.primary,
                          onSurface: widget.onSurface,
                          palette: palette,
                          onTap: () => _changeFilter(_AvatarStoreFilter.owned),
                        ),
                        _AvatarFilterChip(
                          label: 'Para comprar',
                          selected:
                              _activeFilter == _AvatarStoreFilter.unlockable,
                          primary: widget.primary,
                          onSurface: widget.onSurface,
                          palette: palette,
                          onTap: () =>
                              _changeFilter(_AvatarStoreFilter.unlockable),
                        ),
                        _AvatarRarityDropdown(
                          selectedRarity: _activeRarity,
                          availableRarities: _availableRarities,
                          primary: widget.primary,
                          onSurface: widget.onSurface,
                          palette: palette,
                          onSelected: _changeRarity,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: visibleItems.isEmpty
                        ? SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                            child: _AvatarEmptyState(
                              onSurface: widget.onSurface,
                              palette: palette,
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                                palette: palette,
                                onTap: () {
                                  setState(() {
                                    _selectedSeed = item.seed;
                                  });
                                },
                              );
                            },
                          ),
                  ),
                  _AvatarStoreFooter(
                    onSurface: widget.onSurface,
                    palette: palette,
                    isSubmitting: _isSubmitting,
                    canSubmit: _canSubmit,
                    primaryActionColor: primaryButtonColor,
                    primaryActionLabel: primaryButtonLabel,
                    primaryActionIcon: primaryButtonIcon,
                    onClose: () => Navigator.pop(context),
                    onSubmit: _submitSelection,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarStorePalette {
  const _AvatarStorePalette({
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurfaceMuted,
    required this.primaryForeground,
    required this.border,
    required this.shadow,
    required this.isDark,
  });

  factory _AvatarStorePalette.fromContext(BuildContext context) {
    final colors = context.cognixColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _AvatarStorePalette(
      surfaceContainer: colors.surfaceContainer,
      surfaceContainerHigh: colors.surfaceContainerHigh,
      onSurfaceMuted: colors.onSurfaceMuted,
      primaryForeground: isDark ? const Color(0xFF060E20) : Colors.white,
      border: colors.onSurfaceMuted.withValues(alpha: isDark ? 0.12 : 0.18),
      shadow: Colors.black.withValues(alpha: isDark ? 0.22 : 0.08),
      isDark: isDark,
    );
  }

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurfaceMuted;
  final Color primaryForeground;
  final Color border;
  final Color shadow;
  final bool isDark;
}
