part of 'writing_result_screen.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            color: colors.onSurface,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: colors.onSurfaceMuted,
            fontSize: 12.8,
            height: 1.38,
          ),
        ),
      ],
    );
  }
}
