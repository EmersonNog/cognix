part of '../plan_hub_screen.dart';

class _PlanHubHeroCard extends StatelessWidget {
  const _PlanHubHeroCard({required this.palette});

  final _PlanHubPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.borderColor),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [palette.primary, palette.primaryDim],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.payments_rounded,
              color: palette.primaryForeground,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plano e cobranca',
                  style: GoogleFonts.manrope(
                    color: palette.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Acesse a contratação premium e a área de gerenciamento da sua assinatura atual.',
                  style: GoogleFonts.inter(
                    color: palette.onSurfaceMuted,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
