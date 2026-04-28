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
        _SubscriptionStatusHeader(
          colors: colors,
          eyebrow: 'STATUS DO ACESSO',
          title: isScheduled ? 'Cancelamento agendado' : 'Assinatura cancelada',
          description: isScheduled
              ? 'A renovação automática foi interrompida, mas o acesso segue ativo até o encerramento do ciclo.'
              : 'Não existem novas cobranças programadas para este plano.',
          icon: isScheduled ? Icons.event_busy_rounded : Icons.cancel_rounded,
          accent: badgeColor,
          status: _StatusPill(
            label: isScheduled ? 'Agendada' : 'Cancelada',
            color: badgeColor,
          ),
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
