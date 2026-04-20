import 'package:flutter/material.dart';

import '../../../theme/cognix_theme_colors.dart';

class ProfileOpenPanelCard extends StatelessWidget {
  const ProfileOpenPanelCard({
    super.key,
    required this.onTap,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    this.icon = Icons.dashboard_customize_rounded,
    this.title = 'Abrir painel pessoal',
    this.subtitle =
        'Acesse configurações, planos e suporte da sua conta em uma tela separada.',
    this.badge,
    this.isFeatured = false,
  });

  final VoidCallback onTap;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final backgroundColor = isFeatured
        ? Color.alphaBlend(
            primary.withValues(alpha: 0.14),
            colors.surfaceContainerHigh,
          )
        : colors.surfaceContainer;
    final borderColor = isFeatured
        ? primary.withValues(alpha: 0.26)
        : onSurfaceMuted.withValues(alpha: 0.12);
    final iconContainerColor = primary.withValues(
      alpha: isFeatured ? 0.18 : 0.14,
    );
    final titleColor = onSurface;
    final trailingColor = isFeatured ? primary : onSurfaceMuted;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: isFeatured ? 0.12 : 0.07),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
            if (isFeatured)
              BoxShadow(
                color: primary.withValues(alpha: 0.12),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: isFeatured ? 48 : 44,
              height: isFeatured ? 48 : 44,
              decoration: BoxDecoration(
                color: iconContainerColor,
                borderRadius: BorderRadius.circular(isFeatured ? 16 : 14),
              ),
              child: Icon(icon, color: primary, size: isFeatured ? 24 : 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badge != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: primary.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Text(
                        badge!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: onSurfaceMuted,
                      height: 1.4,
                    ),
                  ),
                  if (isFeatured) ...[
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ver agora',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.north_east_rounded,
                          size: 16,
                          color: primary,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: trailingColor,
            ),
          ],
        ),
      ),
    );
  }
}
