part of '../avatar_store_dialog.dart';

class _AvatarFilterChip extends StatelessWidget {
  const _AvatarFilterChip({
    required this.label,
    required this.selected,
    required this.primary,
    required this.onSurface,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color primary;
  final Color onSurface;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? primary.withValues(alpha: 0.14)
                : const Color(0xFF141E39),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? primary.withValues(alpha: 0.22)
                  : Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: selected ? primary : onSurface.withValues(alpha: 0.82),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarRarityDropdown extends StatelessWidget {
  const _AvatarRarityDropdown({
    required this.selectedRarity,
    required this.availableRarities,
    required this.primary,
    required this.onSurface,
    required this.onSelected,
  });

  final String selectedRarity;
  final List<String> availableRarities;
  final Color primary;
  final Color onSurface;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final hasCustomSelection = selectedRarity != _allRaritiesFilterValue;

    return PopupMenuButton<String>(
      tooltip: 'Filtrar por raridade',
      initialValue: selectedRarity,
      onSelected: onSelected,
      color: const Color(0xFF182242),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: _allRaritiesFilterValue,
          child: Text(
            'Todas',
            style: GoogleFonts.plusJakartaSans(
              color: onSurface,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...availableRarities.map(
          (rarity) => PopupMenuItem<String>(
            value: rarity,
            child: Text(
              _formatAvatarRarity(rarity),
              style: GoogleFonts.plusJakartaSans(
                color: onSurface,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: hasCustomSelection
              ? primary.withValues(alpha: 0.14)
              : const Color(0xFF141E39),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: hasCustomSelection
                ? primary.withValues(alpha: 0.22)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Icon(
          Icons.tune_rounded,
          size: 18,
          color: hasCustomSelection
              ? primary
              : onSurface.withValues(alpha: 0.78),
        ),
      ),
    );
  }
}

class _AvatarStoreTile extends StatelessWidget {
  const _AvatarStoreTile({
    required this.item,
    required this.isSelected,
    required this.primary,
    required this.onSurface,
    required this.onTap,
  });

  final ProfileAvatarStoreItem item;
  final bool isSelected;
  final Color primary;
  final Color onSurface;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = item.equipped
        ? const Color(0xFFFFD977)
        : item.owned
        ? primary
        : item.affordable
        ? const Color(0xFF78D6B7)
        : const Color(0xFFFF8B7A);
    final rarityColor = _avatarRarityColor(item.rarity, primary);

    final badgeText = item.equipped
        ? 'Em uso'
        : item.owned
        ? 'Comprado'
        : item.affordable
        ? 'Liberar'
        : 'Bloqueado';
    final priceFlagText = item.equipped
        ? 'Ativo'
        : item.owned
        ? 'Liberado'
        : item.costCoins <= 0
        ? 'Gratis'
        : '${formatCoinsLabel(item.costCoins).replaceAll('moedas', '')} 🪙';
    final metadataText = item.theme.trim().isEmpty
        ? _formatAvatarRarity(item.rarity)
        : '${item.theme} · ${_formatAvatarRarity(item.rarity)}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isSelected
                ? Color.alphaBlend(
                    accent.withValues(alpha: 0.12),
                    const Color(0xFF141E39),
                  )
                : const Color(0xFF141E39),
            border: Border.all(
              color: isSelected
                  ? accent.withValues(alpha: 0.24)
                  : Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(18),
                    ),
                    color: accent.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badgeText,
                          style: GoogleFonts.plusJakartaSans(
                            color: accent,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          priceFlagText,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            color: onSurface.withValues(alpha: 0.82),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 146,
                        height: 146,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.95),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.22),
                            width: 2,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: accent.withValues(alpha: 0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipOval(child: RandomAvatar(item.seed)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      color: onSurface,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    metadataText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: rarityColor.withValues(alpha: 0.92),
                      fontSize: 10.1,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarEmptyState extends StatelessWidget {
  const _AvatarEmptyState({required this.onSurface});

  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF141E39),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.sentiment_satisfied_alt_rounded,
            color: onSurface.withValues(alpha: 0.72),
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            'Nenhum avatar encontrado nesse filtro.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
