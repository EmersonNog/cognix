part of '../plan_screen.dart';

class _PlanStatusMessage extends StatelessWidget {
  const _PlanStatusMessage({
    required this.colors,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final CognixThemeColors colors;
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.primary, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.onSurface,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: GoogleFonts.inter(
                    color: colors.onSurfaceMuted,
                    fontSize: 11.7,
                    height: 1.35,
                  ),
                ),
                if (action != null) ...[const SizedBox(height: 4), action!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
