part of '../subscription_screen.dart';

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    required this.colors,
    required this.icon,
    required this.accent,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final CognixThemeColors colors;
  final IconData icon;
  final Color accent;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accent.withValues(alpha: 0.18)),
          ),
          child: Icon(icon, color: accent, size: 27),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: GoogleFonts.manrope(
            color: colors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: colors.onSurfaceMuted,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        if (action != null) ...[const SizedBox(height: 16), action!],
      ],
    );
  }
}

class _SubscriptionLoadingContent extends StatelessWidget {
  const _SubscriptionLoadingContent({required this.colors});

  final CognixThemeColors colors;

  @override
  Widget build(BuildContext context) {
    final fill = colors.onSurfaceMuted.withValues(alpha: 0.13);
    final accentFill = colors.primary.withValues(alpha: 0.14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _SkeletonBox(width: 54, height: 54, radius: 18, color: accentFill),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(width: 142, height: 18, color: fill),
                  const SizedBox(height: 9),
                  _SkeletonBox(width: 104, height: 12, color: fill),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Divider(
          color: colors.onSurfaceMuted.withValues(alpha: 0.12),
          height: 1,
        ),
        const SizedBox(height: 16),
        _SkeletonBox(width: double.infinity, height: 14, color: fill),
        const SizedBox(height: 11),
        _SkeletonBox(width: 220, height: 14, color: fill),
        const SizedBox(height: 20),
        _SkeletonBox(
          width: double.infinity,
          height: 48,
          radius: 16,
          color: fill,
        ),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.color,
    this.radius = 999,
  });

  final double width;
  final double height;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
