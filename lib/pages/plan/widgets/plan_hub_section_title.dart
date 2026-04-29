part of '../plan_hub_screen.dart';

class _PlanHubSectionTitle extends StatelessWidget {
  const _PlanHubSectionTitle({
    required this.palette,
    required this.title,
    required this.subtitle,
  });

  final _PlanHubPalette palette;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            color: palette.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: palette.onSurfaceMuted,
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
