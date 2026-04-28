part of '../../../study_plan_screen.dart';

class _HeroStatsStrip extends StatelessWidget {
  const _HeroStatsStrip({
    required this.palette,
    required this.items,
    required this.values,
    this.locked = false,
  });

  final _StudyPlanPalette palette;
  final List<({IconData icon, String label})> items;
  final List<String> values;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: palette.onSurfaceMuted.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: List<Widget>.generate(items.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Container(
              width: 1,
              height: 38,
              color: palette.onSurfaceMuted.withValues(alpha: 0.12),
            );
          }

          final itemIndex = index ~/ 2;
          final item = items[itemIndex];
          return Expanded(
            child: _HeroStatCell(
              icon: item.icon,
              label: item.label,
              value: values[itemIndex],
              palette: palette,
              locked: locked,
            ),
          );
        }),
      ),
    );
  }
}

class _HeroStatCell extends StatelessWidget {
  const _HeroStatCell({
    required this.value,
    required this.label,
    required this.icon,
    required this.palette,
    this.locked = false,
  });

  final String value;
  final String label;
  final IconData icon;
  final _StudyPlanPalette palette;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: palette.primary, size: 12),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: palette.onSurfaceMuted,
                    fontSize: 10.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (locked)
            Icon(
              Icons.lock_rounded,
              color: palette.onSurface.withValues(alpha: 0.82),
              size: 16,
            )
          else
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                maxLines: 1,
                style: GoogleFonts.plusJakartaSans(
                  color: palette.onSurface,
                  fontSize: 11.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
