part of '../../subscription_screen.dart';

class _ActiveSubscriptionContent extends StatelessWidget {
  const _ActiveSubscriptionContent({
    required this.colors,
    required this.subscription,
    required this.isCancelling,
    required this.onCancel,
    required this.onManageGooglePlay,
  });

  final CognixThemeColors colors;
  final SubscriptionStatus subscription;
  final bool isCancelling;
  final VoidCallback? onCancel;
  final VoidCallback? onManageGooglePlay;

  @override
  Widget build(BuildContext context) {
    final isGooglePlay = subscription.isGooglePlay;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SubscriptionStatusHeader(
          colors: colors,
          eyebrow: 'PLANO ATIVO',
          title: _planTitle(subscription.planId),
          description: isGooglePlay
              ? 'Seu acesso premium está liberado e a assinatura e gerenciada pelo Google Play.'
              : 'Seu acesso premium está liberado e a cobrança segue conforme o ciclo do plano.',
          icon: Icons.workspace_premium_rounded,
          accent: subscription.isActive ? colors.success : colors.primary,
          status: _StatusBadge(colors: colors, status: subscription),
        ),
        const SizedBox(height: 18),
        _SubscriptionSummaryPanel(
          colors: colors,
          rows: [
            _SubscriptionSummaryRowData(
              label: 'Ciclo',
              value: _billingCycleLabel(subscription.planId),
            ),
            _SubscriptionSummaryRowData(
              label: 'Acesso',
              value: _currentPeriodLabel(subscription),
            ),
            _SubscriptionSummaryRowData(
              label: 'Cobrança',
              value: isGooglePlay
                  ? 'Google Play'
                  : subscription.canCancel
                  ? 'Renovação ativa'
                  : 'Aguardando confirmação',
            ),
          ],
        ),
        if (isGooglePlay && onManageGooglePlay != null) ...[
          const SizedBox(height: 18),
          Text(
            'Para trocar o plano, cancelar ou revisar a renovação, abra a central de assinaturas do Google Play.',
            style: GoogleFonts.inter(
              color: colors.onSurfaceMuted,
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onManageGooglePlay,
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Gerenciar no Google Play'),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: colors.primary,
                side: BorderSide(color: colors.primary.withValues(alpha: 0.34)),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ] else if (subscription.canCancel) ...[
          const SizedBox(height: 18),
          Text(
            'Ao cancelar, novas cobranças são interrompidas. O acesso continua até o fim do período já pago.',
            style: GoogleFonts.inter(
              color: colors.onSurfaceMuted,
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onCancel,
              icon: isCancelling
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.danger,
                        ),
                      ),
                    )
                  : const Icon(Icons.cancel_rounded),
              label: Text(
                isCancelling ? 'Cancelando...' : 'Cancelar assinatura',
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: colors.danger,
                disabledBackgroundColor: Colors.transparent,
                disabledForegroundColor: colors.onSurfaceMuted.withValues(
                  alpha: 0.70,
                ),
                side: BorderSide(color: colors.danger.withValues(alpha: 0.34)),
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
