part of '../../room_widgets.dart';

class _SubscriptionFeatureChip extends StatelessWidget {
  const _SubscriptionFeatureChip({
    required this.palette,
    required this.feature,
  });

  final MultiplayerPalette palette;
  final _SubscriptionFeatureData feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.onSurface.withValues(alpha: 0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(feature.icon, color: palette.primary, size: 16),
          const SizedBox(width: 8),
          Text(
            feature.label,
            style: GoogleFonts.inter(
              color: palette.onSurface,
              fontSize: 12.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
