part of '../../study_plan_screen.dart';

class _StudyPlanFooterBar extends StatelessWidget {
  const _StudyPlanFooterBar({
    required this.palette,
    required this.isSaving,
    required this.onSave,
  });

  final _StudyPlanPalette palette;
  final bool isSaving;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: BoxDecoration(
        color: palette.surfaceContainerHigh.withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(
            color: palette.onSurfaceMuted.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: isSaving ? null : onSave,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: palette.primary,
              foregroundColor: palette.surface,
              disabledBackgroundColor: palette.primary.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_rounded),
            label: Text(
              isSaving ? 'Salvando plano...' : 'Salvar plano',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
