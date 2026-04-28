part of '../../subscription_screen.dart';

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.colors, required this.status});

  final CognixThemeColors colors;
  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    final label = status.isActive ? 'Ativa' : 'Em processamento';
    final color = status.isActive ? colors.success : colors.primary;

    return _StatusPill(label: label, color: color);
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.15,
        ),
      ),
    );
  }
}

class _SubscriptionStatusHeader extends StatelessWidget {
  const _SubscriptionStatusHeader({
    required this.colors,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.status,
  });

  final CognixThemeColors colors;
  final String eyebrow;
  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final Widget status;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: accent.withValues(alpha: 0.20)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: accent, size: 14),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        eyebrow,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: accent,
                          fontSize: 10.4,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            status,
          ],
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: GoogleFonts.manrope(
            color: colors.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: GoogleFonts.inter(
            color: colors.onSurfaceMuted,
            fontSize: 12.8,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
