part of '../avatar_store_dialog.dart';

class _AvatarShopHero extends StatelessWidget {
  const _AvatarShopHero({
    required this.title,
    required this.subtitle,
    required this.balanceLabel,
    required this.badgeLabel,
    required this.badgeColor,
    required this.item,
    required this.priceLabel,
    required this.rarityLabel,
    required this.themeLabel,
    required this.rarityColor,
    required this.palette,
    required this.description,
    required this.primary,
    required this.onSurface,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final String balanceLabel;
  final String badgeLabel;
  final Color badgeColor;
  final ProfileAvatarStoreItem? item;
  final String? priceLabel;
  final String? rarityLabel;
  final String? themeLabel;
  final Color rarityColor;
  final _AvatarStorePalette palette;
  final String description;
  final Color primary;
  final Color onSurface;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            palette.surfaceContainerHigh,
            palette.surfaceContainer,
          ],
        ),
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      primary.withValues(alpha: 0.24),
                      primary.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primary.withValues(alpha: 0.14)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: primary.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.face_retouching_natural_rounded,
                  color: primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: GoogleFonts.manrope(
                          color: onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.02,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: onSurface.withValues(alpha: 0.66),
                          fontSize: 11.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 42,
                height: 42,
                child: IconButton(
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    backgroundColor: palette.surfaceContainerHigh,
                    side: BorderSide(color: palette.border),
                  ),
                  icon: Icon(Icons.close_rounded, color: onSurface, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final statusPill = _AvatarHeroPill(
                icon: Icons.check_circle_outline_rounded,
                label: badgeLabel,
                color: badgeColor,
              );
              final balancePill = _AvatarHeroPill(
                icon: Icons.monetization_on_rounded,
                label: balanceLabel,
                color: const Color(0xFFFFD977),
              );

              if (constraints.maxWidth < 300) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[statusPill, balancePill],
                );
              }

              return Row(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: statusPill,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: balancePill,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          _AvatarSpotlightCard(
            item: item,
            priceLabel: priceLabel,
            rarityLabel: rarityLabel,
            themeLabel: themeLabel,
            rarityColor: rarityColor,
            description: description,
            primary: primary,
            onSurface: onSurface,
            palette: palette,
            compact: true,
          ),
        ],
      ),
    );
  }
}

class _AvatarHeroPill extends StatelessWidget {
  const _AvatarHeroPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
