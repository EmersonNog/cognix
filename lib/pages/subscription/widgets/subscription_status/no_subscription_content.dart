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
        ? 'Experiência Cognix'
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
        _SubscriptionStatusHeader(
          colors: colors,
          eyebrow: 'STATUS DO ACESSO',
          title: title,
          description: status.trialAvailable
              ? 'Ative sua experiência quando quiser e libere todos os recursos por 3 dias.'
              : trialExpired
              ? 'Seu período gratuito terminou. Você pode seguir com um plano pago quando quiser.'
              : 'Nenhum acesso premium está ativo no momento.',
          icon: status.trialAvailable
              ? Icons.auto_awesome_rounded
              : trialExpired
              ? Icons.schedule_rounded
              : Icons.lock_outline_rounded,
          accent: pillColor,
          status: _StatusPill(label: pillLabel, color: pillColor),
        ),
        const SizedBox(height: 18),
        _SubscriptionSummaryPanel(
          colors: colors,
          rows: [
            _SubscriptionSummaryRowData(
              label: 'Acesso',
              value: status.trialAvailable
                  ? 'Disponível por 3 dias'
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
              ? 'Ative agora para começar seu período gratuito sem cobrança.'
              : trialEndLabel == null
              ? 'Para contratar um plano, volte ao painel pessoal e toque em Assinar premium.'
              : 'Sua experiência terminou em $trialEndLabel. Para contratar um plano, volte ao painel pessoal e toque em Assinar premium.',
          style: GoogleFonts.inter(
            color: colors.onSurfaceMuted,
            fontSize: 12.5,
            height: 1.45,
          ),
        ),
        if (status.trialAvailable) ...[
          const SizedBox(height: 16),
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
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
