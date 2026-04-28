part of '../../subscription_screen.dart';

class _ActiveSubscriptionContent extends StatelessWidget {
  const _ActiveSubscriptionContent({
    required this.colors,
    required this.subscription,
    required this.isCancelling,
    required this.onCancel,
  });

  final CognixThemeColors colors;
  final SubscriptionStatus subscription;
  final bool isCancelling;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
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
                    'Assinatura atual',
                    style: GoogleFonts.inter(
                      color: colors.onSurfaceMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _planTitle(subscription.planId),
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
            _StatusBadge(colors: colors, status: subscription),
          ],
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
              label: 'Cobranãa',
              value: subscription.canCancel
                  ? 'Renovação ativa'
                  : 'Aguardando confirmação',
            ),
          ],
        ),
        if (subscription.canCancel) ...[
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
