import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'training_session_screen.dart';

class TrainingDetailScreen extends StatelessWidget {
  const TrainingDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.badgeColor,
    required this.countLabel,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    this.progress = 0.68,
  });

  final String title;
  final String description;
  final String badgeLabel;
  final Color badgeColor;
  final String countLabel;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060E20),
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.manrope(
            color: onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: surfaceContainerHigh,
        elevation: 0,
        leading: BackButton(color: onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pronto para praticar?',
              style: GoogleFonts.manrope(
                color: onSurface,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nossa tecnologia de aprendizado adaptativo ajusta cada questão ao seu nível em $title',
              style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 13),
            ),
            const SizedBox(height: 18),

            // Active discipline card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DISCIPLINA ATIVA',
                    style: GoogleFonts.plusJakartaSans(
                      color: onSurfaceMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.functions_rounded,
                          color: badgeColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.manrope(
                                color: onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              style: GoogleFonts.inter(
                                color: onSurfaceMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badgeLabel.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            color: badgeColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TrainingSessionScreen(
                              surfaceContainer: surfaceContainerHigh,
                              surfaceContainerHigh: surfaceContainerHigh,
                              onSurface: onSurface,
                              onSurfaceMuted: onSurfaceMuted,
                              primary: primary,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Iniciar Simulado',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Quick actions
            Text(
              'AÇÕES RÁPIDAS',
              style: GoogleFonts.plusJakartaSans(
                color: onSurfaceMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                _QuickActionItem(
                  icon: Icons.menu_book_rounded,
                  label: 'Revisar Conteúdo',
                  subtitle: '4 módulos de Derivadas',
                  surfaceContainerHigh: surfaceContainerHigh,
                  onSurfaceMuted: onSurfaceMuted,
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _QuickActionItem(
                  icon: Icons.article_rounded,
                  label: 'Ver Resumo',
                  subtitle: 'Mapa mental interativo',
                  surfaceContainerHigh: surfaceContainerHigh,
                  onSurfaceMuted: onSurfaceMuted,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SEU PROGRESSO',
                  style: GoogleFonts.plusJakartaSans(
                    color: onSurfaceMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: onSurfaceMuted.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation<Color>(primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.surfaceContainerHigh,
    required this.onSurfaceMuted,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color surfaceContainerHigh;
  final Color onSurfaceMuted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: onSurfaceMuted.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: onSurfaceMuted, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded, color: onSurfaceMuted),
            ],
          ),
        ),
      ),
    );
  }
}
