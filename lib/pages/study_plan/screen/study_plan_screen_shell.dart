part of '../study_plan_screen.dart';

class _StudyPlanHeader extends StatelessWidget {
  const _StudyPlanHeader({required this.palette, required this.onClose});

  final _StudyPlanPalette palette;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StudyPlanHeaderCard(palette: palette)),
        const SizedBox(width: 10),
        _StudyPlanCloseButton(palette: palette, onClose: onClose),
      ],
    );
  }
}

class _StudyPlanHeaderCard extends StatelessWidget {
  const _StudyPlanHeaderCard({required this.palette});

  final _StudyPlanPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: palette.onSurfaceMuted.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: palette.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.event_note_rounded,
              color: palette.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Plano de estudos',
                  style: GoogleFonts.manrope(
                    color: palette.onSurface,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Defina seu ritmo, metas e prioridades da semana.',
                  style: GoogleFonts.inter(
                    color: palette.onSurfaceMuted,
                    fontSize: 11.8,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StudyPlanCloseButton extends StatelessWidget {
  const _StudyPlanCloseButton({required this.palette, required this.onClose});

  final _StudyPlanPalette palette;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClose,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: palette.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: palette.onSurfaceMuted.withValues(alpha: 0.12),
            ),
          ),
          child: Icon(
            Icons.close_rounded,
            color: palette.onSurfaceMuted,
            size: 20,
          ),
        ),
      ),
    );
  }
}
