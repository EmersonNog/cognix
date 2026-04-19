part of '../room_widgets.dart';

class MultiplayerRoomStatusCard extends StatelessWidget {
  const MultiplayerRoomStatusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.palette,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final MultiplayerPalette palette;

  @override
  Widget build(BuildContext context) {
    return MultiplayerPanel(
      palette: palette,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: palette.secondary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: palette.secondary, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    color: palette.onSurface,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: palette.onSurfaceMuted,
                    fontSize: 11.8,
                    height: 1.3,
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
