part of '../avatar_store_dialog.dart';

class _AvatarSpotlightCard extends StatelessWidget {
  const _AvatarSpotlightCard({
    required this.item,
    required this.priceLabel,
    required this.rarityLabel,
    required this.themeLabel,
    required this.rarityColor,
    required this.description,
    required this.primary,
    required this.onSurface,
  });

  final ProfileAvatarStoreItem? item;
  final String? priceLabel;
  final String? rarityLabel;
  final String? themeLabel;
  final Color rarityColor;
  final String description;
  final Color primary;
  final Color onSurface;

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: item == null
            ? const Color(0xFF141E39)
            : Color.alphaBlend(
                accent.withValues(alpha: 0.12),
                const Color(0xFF141E39),
              ),
        border: Border.all(
          color: item == null
              ? Colors.white.withValues(alpha: 0.05)
              : accent.withValues(alpha: 0.2),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 76,
            height: 76,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.92),
              border: Border.all(
                color: accent.withValues(alpha: 0.28),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: item == null
                  ? Container(color: Colors.white.withValues(alpha: 0.04))
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
                        priceLabel ?? 'Selecao',
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
                      size: 16,
                      color: rarityColor.withValues(alpha: 0.78),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (themeLabel != null && themeLabel!.trim().isNotEmpty) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    themeLabel!,
                    style: GoogleFonts.plusJakartaSans(
                      color: rarityColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    color: onSurface.withValues(alpha: 0.72),
                    fontSize: 11.5,
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
