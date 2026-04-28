part of '../../subscription_screen.dart';

class _TrialActiveContent extends StatelessWidget {
  const _TrialActiveContent({required this.colors, required this.status});

  final CognixThemeColors colors;
  final EntitlementStatus status;

  @override
  Widget build(BuildContext context) {
    final accessLabel = _trialAccessLabel(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status da assinatura',
                    style: GoogleFonts.inter(
                      color: colors.onSurfaceMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Experiência Cognix ativa',
                    style: GoogleFonts.manrope(
                      color: colors.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _StatusPill(label: 'Ativa', color: colors.success),
          ],
        ),
        const SizedBox(height: 18),
        _SubscriptionSummaryPanel(
          colors: colors,
          rows: [
            _SubscriptionSummaryRowData(
              label: 'Acesso',
              value: accessLabel ?? 'Todas as funções liberadas',
            ),
            const _SubscriptionSummaryRowData(
              label: 'Cobrança',
              value: 'Sem cobrança',
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Todas as funções ficam liberadas durante a experiência.',
          style: GoogleFonts.inter(
            color: colors.onSurfaceMuted,
            fontSize: 12.5,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
