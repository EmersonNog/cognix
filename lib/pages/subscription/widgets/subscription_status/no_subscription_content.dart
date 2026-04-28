part of '../../subscription_screen.dart';

class _NoSubscriptionContent extends StatelessWidget {
  const _NoSubscriptionContent({
    required this.colors,
    required this.status,
    required this.isStartingTrial,
    required this.onStartTrial,
  });

  final CognixThemeColors colors;
  final EntitlementStatus status;
  final bool isStartingTrial;
  final VoidCallback? onStartTrial;

  @override
  Widget build(BuildContext context) {
    final trialExpired = status.isTrialExpired;
    final title = status.trialAvailable
        ? 'Experiência Cognix 3 dias'
        : trialExpired
        ? 'Experiência encerrada'
        : 'Nenhuma assinatura ativa';
    final pillLabel = status.trialAvailable
        ? 'Disponível'
        : trialExpired
        ? 'Encerrada'
        : 'Inativa';
    final pillColor = status.trialAvailable
        ? colors.primary
        : trialExpired
        ? colors.danger
        : colors.onSurfaceMuted;
    final trialEndLabel = _formatDate(status.trialEndsAt);

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
                    'Status do acesso',
                    style: GoogleFonts.inter(
                      color: colors.onSurfaceMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
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
            _StatusPill(label: pillLabel, color: pillColor),
          ],
        ),
        const SizedBox(height: 18),
        _SubscriptionSummaryPanel(
          colors: colors,
          rows: [
            _SubscriptionSummaryRowData(
              label: 'Acesso',
              value: status.trialAvailable
                  ? 'Todas as funções por 3 dias'
                  : trialExpired
                  ? 'Trial encerrado'
                  : 'Não liberado',
            ),
            _SubscriptionSummaryRowData(
              label: 'Cobrança',
              value: status.trialAvailable
                  ? 'Sem cobrança'
                  : 'Sem assinatura ativa',
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          status.trialAvailable
              ? 'Ative quando quiser iniciar seu período gratuito.'
              : trialEndLabel == null
              ? 'Assine um plano para liberar novamente.'
              : 'Sua experiência terminou em $trialEndLabel. Assine um plano para liberar novamente.',
          style: GoogleFonts.inter(
            color: colors.onSurfaceMuted,
            fontSize: 12.5,
            height: 1.45,
          ),
        ),
        if (status.trialAvailable) ...[
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onStartTrial,
              icon: isStartingTrial
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.surface,
                        ),
                      ),
                    )
                  : const Icon(Icons.bolt_rounded),
              label: Text(
                isStartingTrial ? 'Ativando...' : 'Ativar experiência gratuita',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.surface,
                disabledBackgroundColor: colors.onSurfaceMuted.withValues(
                  alpha: 0.16,
                ),
                disabledForegroundColor: colors.onSurfaceMuted,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
