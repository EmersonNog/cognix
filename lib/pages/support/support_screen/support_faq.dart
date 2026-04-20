part of '../support_screen.dart';

class _SupportFaqCard extends StatelessWidget {
  const _SupportFaqCard({required this.palette, required this.item});

  final _SupportPalette palette;
  final _SupportFaqItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.borderColor),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          iconColor: palette.onSurfaceMuted,
          collapsedIconColor: palette.onSurfaceMuted,
          title: Text(
            item.question,
            style: GoogleFonts.manrope(
              color: palette.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.answer,
                style: GoogleFonts.inter(
                  color: palette.onSurfaceMuted,
                  fontSize: 12.5,
                  height: 1.55,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
