part of '../subscription_screen.dart';

class _SubscriptionHeaderCard extends StatelessWidget {
  const _SubscriptionHeaderCard({required this.colors});

  final CognixThemeColors colors;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(
              colors.primary.withValues(alpha: isDark ? 0.04 : 0.03),
              colors.surfaceContainer,
            ),
            colors.surfaceContainerHigh.withValues(alpha: 0.94),
          ],
        ),
        border: Border.all(
          color: colors.onSurfaceMuted.withValues(alpha: isDark ? 0.12 : 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.07 : 0.03),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.primary.withValues(alpha: 0.16)),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: colors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plano e cobrança',
                  style: GoogleFonts.manrope(
                    color: colors.onSurface,
                    fontSize: 18.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status, acesso e cobranças do seu plano.',
                  style: GoogleFonts.inter(
                    color: colors.onSurfaceMuted,
                    fontSize: 12.5,
                    height: 1.35,
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
