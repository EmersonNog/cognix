part of '../multiplayer_match_panels.dart';

class MatchLoadingPanel extends StatelessWidget {
  const MatchLoadingPanel({super.key, required this.palette});

  final MultiplayerPalette palette;

  @override
  Widget build(BuildContext context) {
    return MultiplayerPanel(
      palette: palette,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircularProgressIndicator(color: palette.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Carregando questões da partida...',
              style: GoogleFonts.inter(
                color: palette.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
