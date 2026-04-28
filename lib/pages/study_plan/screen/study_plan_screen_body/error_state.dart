part of '../../study_plan_screen.dart';

class _StudyPlanErrorState extends StatelessWidget {
  const _StudyPlanErrorState({
    required this.palette,
    required this.message,
    required this.isSubscriptionRequired,
    required this.onRetry,
  });

  final _StudyPlanPalette palette;
  final String message;
  final bool isSubscriptionRequired;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSubscriptionRequired
                  ? Icons.lock_open_rounded
                  : Icons.wifi_tethering_error_rounded,
              color: palette.primary,
              size: 36,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: palette.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSubscriptionRequired
                  ? 'Gerencie seu acesso para liberar o plano de estudos.'
                  : 'Tente novamente para abrir seu plano de estudos.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: palette.onSurfaceMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: palette.surfaceContainerHigh,
              ),
              child: Text(
                isSubscriptionRequired ? 'Gerenciar acesso' : 'Recarregar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
