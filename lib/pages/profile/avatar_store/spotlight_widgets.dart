part of '../avatar_store_dialog.dart';

class _AvatarSpotlightCard extends StatelessWidget {
  const _AvatarSpotlightCard({
    required this.item,
    required this.priceLabel,
    required this.rarityLabel,
    required this.themeLabel,
    required this.rarityColor,
    required this.palette,
    required this.description,
    required this.primary,
    required this.onSurface,
    this.compact = false,
  });

  final ProfileAvatarStoreItem? item;
  final String? priceLabel;
  final String? rarityLabel;
  final String? themeLabel;
  final Color rarityColor;
  final _AvatarStorePalette palette;
  final String description;
  final Color primary;
  final Color onSurface;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent = item?.equipped == true
        ? const Color(0xFFFFD977)
        : item?.owned == true
        ? primary
        : item?.affordable == true
        ? const Color(0xFF78D6B7)
        : const Color(0xFFFF8B7A);

    final title = item?.title ?? 'Sem avatar selecionado';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(compact ? 22 : 24),
        color: item == null
            ? palette.surfaceContainerHigh
            : Color.alphaBlend(
                accent.withValues(alpha: compact ? 0.1 : 0.12),
                palette.surfaceContainerHigh,
              ),
        border: Border.all(
          color: item == null ? palette.border : accent.withValues(alpha: 0.2),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadow.withValues(alpha: compact ? 0.62 : 0.82),
            blurRadius: compact ? 14 : 18,
            offset: Offset(0, compact ? 8 : 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: compact ? 68 : 76,
            height: compact ? 68 : 76,
            padding: EdgeInsets.all(compact ? 5 : 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: palette.isDark
                  ? Colors.white.withValues(alpha: 0.92)
                  : palette.surfaceContainer,
              border: Border.all(
                color: accent.withValues(alpha: 0.28),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: item == null
                  ? Container(color: palette.surfaceContainerHigh)
                  : RandomAvatar(item!.seed),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        priceLabel ?? 'Seleção',
                        style: GoogleFonts.plusJakartaSans(
                          color: accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (rarityLabel != null) ...<Widget>[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: rarityColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          rarityLabel!,
                          style: GoogleFonts.plusJakartaSans(
                            color: rarityColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: compact ? 14 : 16,
                      color: rarityColor.withValues(alpha: 0.78),
                    ),
                  ],
                ),
                SizedBox(height: compact ? 8 : 10),
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontSize: compact ? 15.5 : 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (themeLabel != null &&
                    themeLabel!.trim().isNotEmpty) ...<Widget>[
                  SizedBox(height: compact ? 3 : 4),
                  Text(
                    themeLabel!,
                    style: GoogleFonts.plusJakartaSans(
                      color: rarityColor,
                      fontSize: compact ? 10.5 : 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                SizedBox(height: compact ? 5 : 6),
                Text(
                  description,
                  maxLines: compact ? 3 : null,
                  overflow: compact
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible,
                  style: GoogleFonts.inter(
                    color: onSurface.withValues(alpha: 0.72),
                    fontSize: compact ? 11 : 11.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
