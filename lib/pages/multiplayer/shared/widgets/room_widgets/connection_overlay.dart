part of '../room_widgets.dart';

class MultiplayerConnectionOverlay extends StatelessWidget {
  const MultiplayerConnectionOverlay({
    super.key,
    required this.palette,
    required this.title,
    required this.message,
    this.icon = Icons.wifi_find_rounded,
    this.remainingSeconds,
  });

  final MultiplayerPalette palette;
  final String title;
  final String message;
  final IconData icon;
  final int? remainingSeconds;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            palette.surface.withValues(alpha: 0.78),
            palette.surfaceContainer.withValues(alpha: 0.92),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 360),
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  palette.surfaceContainerHigh.withValues(alpha: 0.98),
                  palette.surfaceContainer.withValues(alpha: 0.96),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: palette.primary.withValues(alpha: 0.14),
              ),
              boxShadow: [
                BoxShadow(
                  color: palette.surface.withValues(alpha: 0.36),
                  blurRadius: 28,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        palette.primary.withValues(alpha: 0.2),
                        palette.secondary.withValues(alpha: 0.22),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 54,
                        height: 54,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            palette.primary,
                          ),
                        ),
                      ),
                      Icon(icon, color: palette.primary, size: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    color: palette.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: palette.onSurfaceMuted,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                if (remainingSeconds != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: palette.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: palette.primary.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Text(
                      'Aguardando reconexao: ${remainingSeconds}s',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: palette.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  'Segurando sua sala...',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: palette.secondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
