part of '../avatar_store_dialog.dart';

class _AvatarFilterChip extends StatelessWidget {
  const _AvatarFilterChip({
    required this.label,
    required this.selected,
    required this.primary,
    required this.onSurface,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color primary;
  final Color onSurface;
  final _AvatarStorePalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? primary.withValues(alpha: 0.14)
                : palette.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? primary.withValues(alpha: 0.22)
                  : palette.border,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: selected ? primary : onSurface.withValues(alpha: 0.82),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
