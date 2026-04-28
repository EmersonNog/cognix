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
        _SubscriptionStatusHeader(
          colors: colors,
          eyebrow: 'PERÍODO GRATUITO',
          title: 'Experiência Cognix',
          description:
              'Seu acesso gratuito está ativo agora, com todos os recursos premium liberados.',
          icon: Icons.bolt_rounded,
          accent: colors.success,
          status: _StatusPill(label: 'Ativa', color: colors.success),
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
          'Aproveite este período para testar escrita, desempenho, plano de estudos e multiplayer.',
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
