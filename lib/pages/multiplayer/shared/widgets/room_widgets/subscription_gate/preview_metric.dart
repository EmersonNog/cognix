part of '../../room_widgets.dart';

class _SubscriptionPreviewMetric extends StatelessWidget {
  const _SubscriptionPreviewMetric({
    required this.palette,
    required this.value,
    required this.label,
    this.isAccent = false,
  });

  final MultiplayerPalette palette;
  final String value;
  final String label;
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final color = isAccent ? palette.secondary : palette.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.manrope(
              color: color,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: palette.onSurfaceMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
