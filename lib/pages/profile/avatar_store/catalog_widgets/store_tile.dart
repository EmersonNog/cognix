part of '../../avatar_store_dialog.dart';

class _AvatarStoreTile extends StatelessWidget {
  const _AvatarStoreTile({
    required this.item,
    required this.isSelected,
    required this.primary,
    required this.onSurface,
    required this.palette,
    required this.onTap,
  });

  final ProfileAvatarStoreItem item;
  final bool isSelected;
  final Color primary;
  final Color onSurface;
  final _AvatarStorePalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _avatarTileAccent(item, primary);
    final rarityColor = _avatarRarityColor(item.rarity, primary);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: _tileDecoration(accent),
          child: Stack(
            children: <Widget>[
              _AvatarTileCornerAccent(accent: accent),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _AvatarTileStatusRow(
                    item: item,
                    accent: accent,
                    onSurface: onSurface,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Center(
                      child: _AvatarTileImage(
                        seed: item.seed,
                        accent: accent,
                        palette: palette,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _AvatarTileTitle(title: item.title, onSurface: onSurface),
                  const SizedBox(height: 6),
                  _AvatarTileMetadata(
                    text: _avatarTileMetadata(item),
                    color: rarityColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _tileDecoration(Color accent) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      color: isSelected
          ? Color.alphaBlend(
              accent.withValues(alpha: 0.12),
              palette.surfaceContainerHigh,
            )
          : palette.surfaceContainerHigh,
      border: Border.all(
        color: isSelected ? accent.withValues(alpha: 0.24) : palette.border,
        width: 1,
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: palette.shadow,
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}

class _AvatarTileCornerAccent extends StatelessWidget {
  const _AvatarTileCornerAccent({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
    );
  }
}

class _AvatarTileStatusRow extends StatelessWidget {
  const _AvatarTileStatusRow({
    required this.item,
    required this.accent,
    required this.onSurface,
  });

  final ProfileAvatarStoreItem item;
  final Color accent;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            _avatarTileBadge(item),
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
            _avatarTilePriceFlag(item),
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
    );
  }
}

class _AvatarTileImage extends StatelessWidget {
  const _AvatarTileImage({
    required this.seed,
    required this.accent,
    required this.palette,
  });

  final String seed;
  final Color accent;
  final _AvatarStorePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 146,
      height: 146,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: palette.isDark
            ? Colors.white.withValues(alpha: 0.95)
            : palette.surfaceContainer,
        border: Border.all(color: accent.withValues(alpha: 0.22), width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(child: RandomAvatar(seed)),
    );
  }
}

class _AvatarTileTitle extends StatelessWidget {
  const _AvatarTileTitle({required this.title, required this.onSurface});

  final String title;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.manrope(
        color: onSurface,
        fontSize: 14.5,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _AvatarTileMetadata extends StatelessWidget {
  const _AvatarTileMetadata({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(
        color: color.withValues(alpha: 0.92),
        fontSize: 10.1,
        fontWeight: FontWeight.w700,
        height: 1.35,
      ),
    );
  }
}

Color _avatarTileAccent(ProfileAvatarStoreItem item, Color primary) {
  if (item.equipped) {
    return const Color(0xFFFFD977);
  }
  if (item.owned) {
    return primary;
  }
  if (item.affordable) {
    return const Color(0xFF2EA98F);
  }
  return const Color(0xFFFF8B7A);
}

String _avatarTileBadge(ProfileAvatarStoreItem item) {
  if (item.equipped) {
    return 'Em uso';
  }
  if (item.owned) {
    return 'Comprado';
  }
  if (item.affordable) {
    return 'Liberar';
  }
  return 'Bloqueado';
}

String _avatarTilePriceFlag(ProfileAvatarStoreItem item) {
  if (item.equipped) {
    return 'Ativo';
  }
  if (item.owned) {
    return 'Liberado';
  }
  if (item.costCoins <= 0) {
    return 'Grátis';
  }
  return '${formatCoinsLabel(item.costCoins).replaceAll('moedas', '')} moedas';
}

String _avatarTileMetadata(ProfileAvatarStoreItem item) {
  if (item.theme.trim().isEmpty) {
    return _formatAvatarRarity(item.rarity);
  }
  return '${item.theme} · ${_formatAvatarRarity(item.rarity)}';
}
