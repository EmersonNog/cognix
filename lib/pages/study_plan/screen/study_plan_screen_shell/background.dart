part of '../../study_plan_screen.dart';

class _StudyPlanBackground extends StatelessWidget {
  const _StudyPlanBackground({required this.palette});

  final _StudyPlanPalette palette;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -70,
          right: -30,
          child: _StudyPlanGlow(
            color: palette.secondary.withValues(alpha: 0.22),
          ),
        ),
        Positioned(
          top: 180,
          left: -90,
          child: _StudyPlanGlow(color: palette.primary.withValues(alpha: 0.16)),
        ),
      ],
    );
  }
}

class _StudyPlanGlow extends StatelessWidget {
  const _StudyPlanGlow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
