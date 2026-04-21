import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingMultiplayerPanel extends StatelessWidget {
  const TrainingMultiplayerPanel({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.onCreateRoom,
    required this.onJoinWithPin,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final VoidCallback onCreateRoom;
  final VoidCallback onJoinWithPin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Multiplayer',
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Entre em partidas rapidas, crie salas e desafie outros jogadores em tempo real.',
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _TrainingPanelButton(
                  label: 'Criar sala',
                  icon: Icons.add_circle_outline_rounded,
                  filled: true,
                  primary: primary,
                  onSurface: onSurface,
                  onTap: onCreateRoom,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TrainingPanelButton(
                  label: 'Entrar por PIN',
                  icon: Icons.pin_outlined,
                  filled: false,
                  primary: primary,
                  onSurface: onSurface,
                  onTap: onJoinWithPin,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrainingPanelButton extends StatelessWidget {
  const _TrainingPanelButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.primary,
    required this.onSurface,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final Color primary;
  final Color onSurface;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: filled ? primary : primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: primary.withValues(alpha: 0.14)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: filled ? Colors.white : primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    color: filled ? Colors.white : onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
