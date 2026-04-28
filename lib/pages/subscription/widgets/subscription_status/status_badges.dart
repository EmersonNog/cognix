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
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
