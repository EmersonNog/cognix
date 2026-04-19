part of '../room_widgets.dart';

class MultiplayerPinHero extends StatelessWidget {
  const MultiplayerPinHero({
    super.key,
    required this.pin,
    required this.label,
    required this.caption,
    required this.palette,
  });

  final String pin;
  final String label;
  final String caption;
  final MultiplayerPalette palette;

  @override
  Widget build(BuildContext context) {
    return MultiplayerPanel(
      palette: palette,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              color: palette.primary,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  palette.primary.withValues(alpha: 0.2),
                  palette.surfaceContainerHigh.withValues(alpha: 0.86),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              pin,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: palette.onSurface,
                fontSize: 38,
                fontWeight: FontWeight.w900,
                letterSpacing: 9,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            caption,
            style: GoogleFonts.inter(
              color: palette.onSurfaceMuted,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
