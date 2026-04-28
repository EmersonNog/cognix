part of '../../../study_plan_screen.dart';

class _PlanProgressBar extends StatelessWidget {
  const _PlanProgressBar({required this.palette, required this.percent});

  final _StudyPlanPalette palette;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 11,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: palette.surface.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: palette.onSurfaceMuted.withValues(alpha: 0.1),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: FractionallySizedBox(
              widthFactor: percent / 100,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: palette.primary,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: palette.primary.withValues(alpha: 0.22),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
