part of '../../avatar_store_dialog.dart';

class _AvatarEmptyState extends StatelessWidget {
  const _AvatarEmptyState({required this.onSurface, required this.palette});

  final Color onSurface;
  final _AvatarStorePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.sentiment_satisfied_alt_rounded,
            color: onSurface.withValues(alpha: 0.72),
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            'Nenhum avatar encontrado nesse filtro.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
