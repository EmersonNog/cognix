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
        gradient: LinearGradient(
          colors: [
            Color.alphaBlend(primary.withValues(alpha: 0.10), surfaceContainer),
            Color.alphaBlend(primary.withValues(alpha: 0.03), surfaceContainer),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -18,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [primary.withValues(alpha: 0.18), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            top: -2,
            right: -2,
            child: Icon(
              Icons.groups_rounded,
              size: 82,
              color: primary.withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'JOGUE EM TEMPO REAL',
                  style: GoogleFonts.plusJakartaSans(
                    color: primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Desafie outros jogadores',
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 250,
                child: Text(
                  'Crie salas privadas, entre com PIN e participe de partidas rápidas com mais competição e dinâmica.',
                  style: GoogleFonts.inter(
                    color: onSurfaceMuted,
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _FeatureChip(label: 'Salas privadas'),
                  _FeatureChip(label: 'PIN de acesso'),
                  _FeatureChip(label: 'Partidas rápidas'),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surfaceContainerHigh.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: primary.withValues(alpha: 0.10)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.bolt_rounded, color: primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Escolha como quer entrar e comece uma disputa em poucos toques.',
                        style: GoogleFonts.inter(
                          color: onSurface,
                          fontSize: 12.2,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
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
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
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
              Icon(icon, color: filled ? Colors.white : primary, size: 18),
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
