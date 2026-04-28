part of '../../subscription_screen.dart';

class _CancelledSubscriptionContent extends StatelessWidget {
  const _CancelledSubscriptionContent({
    required this.colors,
    required this.status,
  });

  final CognixThemeColors colors;
  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    final accessLabel = _cancelledAccessLabel(status);
    final isScheduled = status.willCancelAtPeriodEnd && !status.isCancelled;
    final badgeColor = isScheduled ? colors.accent : colors.danger;

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
                    isScheduled
                        ? 'Cancelamento agendado'
                        : 'Assinatura cancelada',
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
            _StatusPill(
              label: isScheduled ? 'Agendada' : 'Cancelada',
              color: badgeColor,
            ),
          ],
        ),
        const SizedBox(height: 18),
        _SubscriptionSummaryPanel(
          colors: colors,
          rows: [
            if (accessLabel != null)
              _SubscriptionSummaryRowData(label: 'Acesso', value: accessLabel),
            _SubscriptionSummaryRowData(
              label: 'Cobrança',
              value: isScheduled
                  ? 'Renovação cancelada'
                  : 'Sem novas cobranças',
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          accessLabel == null
              ? 'Não existem novas cobranças programadas para este plano.'
              : 'Não existem novas cobranças programadas. O acesso permanece até a data informada.',
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
