import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/multiplayer/multiplayer_api.dart';
import 'multiplayer_palette.dart';

class MultiplayerPanel extends StatelessWidget {
  const MultiplayerPanel({
    super.key,
    required this.palette,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final MultiplayerPalette palette;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: palette.surfaceContainer.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: palette.onSurfaceMuted.withValues(alpha: 0.09),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }
}

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

class MultiplayerParticipantTile extends StatelessWidget {
  const MultiplayerParticipantTile({
    super.key,
    required this.participant,
    required this.palette,
    this.canRemove = false,
    this.onRemove,
  });

  final MultiplayerParticipant participant;
  final MultiplayerPalette palette;
  final bool canRemove;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: palette.surfaceContainerHigh.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: participant.isHost
                ? palette.primary.withValues(alpha: 0.18)
                : palette.secondary.withValues(alpha: 0.16),
            child: Text(
              participant.name.trim().isEmpty
                  ? '?'
                  : participant.name.trim()[0].toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                color: participant.isHost ? palette.primary : palette.secondary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.name,
                  style: GoogleFonts.manrope(
                    color: palette.onSurface,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  participant.isHost ? 'Criador da sala' : 'Participante',
                  style: GoogleFonts.inter(
                    color: palette.onSurfaceMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (canRemove)
            IconButton(
              tooltip: 'Remover participante',
              onPressed: onRemove,
              icon: Icon(
                Icons.close_rounded,
                color: palette.onSurfaceMuted,
                size: 20,
              ),
            )
          else
            Icon(
              participant.isHost
                  ? Icons.workspace_premium_rounded
                  : Icons.check_circle_rounded,
              color: participant.isHost
                  ? palette.primary
                  : palette.onSurfaceMuted,
              size: 20,
            ),
        ],
      ),
    );
  }
}
