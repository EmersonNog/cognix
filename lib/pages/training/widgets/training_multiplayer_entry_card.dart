import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingMultiplayerEntryCard extends StatelessWidget {
  const TrainingMultiplayerEntryCard({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withValues(alpha: 0.22)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary.withValues(alpha: 0.12), surfaceContainer],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.groups_2_rounded, color: primary, size: 23),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Desafio multiplayer',
                      style: GoogleFonts.manrope(
                        color: onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Crie uma sala com PIN ou entre em uma disputa existente.',
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted,
                        fontSize: 12.3,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MultiplayerActionButton(
                  label: 'Criar sala',
                  icon: Icons.add_rounded,
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  onTap: () =>
                      Navigator.of(context).pushNamed('multiplayer-create'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MultiplayerActionButton(
                  label: 'Entrar',
                  icon: Icons.login_rounded,
                  backgroundColor: surfaceContainerHigh,
                  foregroundColor: onSurface,
                  onTap: () =>
                      Navigator.of(context).pushNamed('multiplayer-join'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MultiplayerActionButton extends StatelessWidget {
  const _MultiplayerActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    color: foregroundColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
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
