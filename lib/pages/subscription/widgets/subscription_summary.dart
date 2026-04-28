part of '../subscription_screen.dart';

class _SubscriptionSummaryPanel extends StatelessWidget {
  const _SubscriptionSummaryPanel({required this.colors, required this.rows});

  final CognixThemeColors colors;
  final List<_SubscriptionSummaryRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.onSurfaceMuted.withValues(alpha: 0.09),
        ),
      ),
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++) ...[
            _SubscriptionSummaryRow(colors: colors, data: rows[index]),
            if (index < rows.length - 1)
              Divider(
                height: 1,
                color: colors.onSurfaceMuted.withValues(alpha: 0.10),
              ),
          ],
        ],
      ),
    );
  }
}

class _SubscriptionSummaryRowData {
  const _SubscriptionSummaryRowData({required this.label, required this.value});

  final String label;
  final String value;
}

class _SubscriptionSummaryRow extends StatelessWidget {
  const _SubscriptionSummaryRow({required this.colors, required this.data});

  final CognixThemeColors colors;
  final _SubscriptionSummaryRowData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 82,
            child: Text(
              data.label.toUpperCase(),
              style: GoogleFonts.inter(
                color: colors.onSurfaceMuted,
                fontSize: 10.8,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.28,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              data.value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                color: colors.onSurface,
                fontSize: 13.2,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
