import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../subjects/subjects_area_screen.dart';
import '../subjects/subjects_data.dart';

class TrainingTab extends StatelessWidget {
  const TrainingTab({
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
    final areas = [
      _AreaItem(
        area: SubjectsArea.natureza,
        title: 'Ciências da Natureza e suas Tecnologias',
        subtitle: 'Física, Química e Biologia',
        icon: Icons.eco_rounded,
        accent: const Color(0xFF7ED6C5),
      ),
      _AreaItem(
        area: SubjectsArea.humanas,
        title: 'Ciências Humanas e suas Tecnologias',
        subtitle: 'História, Geografia e Sociologia',
        icon: Icons.public_rounded,
        accent: const Color(0xFFF4A261),
      ),
      _AreaItem(
        area: SubjectsArea.linguagens,
        title: 'Linguagens, Códigos e suas Tecnologias',
        subtitle: 'Português, Inglês e Artes',
        icon: Icons.record_voice_over_rounded,
        accent: const Color(0xFF8AB6F9),
      ),
      _AreaItem(
        area: SubjectsArea.matematica,
        title: 'Matemática e suas Tecnologias',
        subtitle: 'Álgebra, Geometria e Estatística',
        icon: Icons.calculate_rounded,
        accent: const Color(0xFFE76F51),
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Áreas de Conhecimento',
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Escolha uma área para iniciar seu treino personalizado.',
            style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 13),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surfaceContainerHigh,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.auto_graph_rounded,
                    color: primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seu ritmo hoje',
                        style: GoogleFonts.manrope(
                          color: onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Foco em consistência • 2 treinos concluídos',
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
                    color: primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '65%',
                    style: GoogleFonts.plusJakartaSans(
                      color: primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'LISTA DE ÁREAS',
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          for (final area in areas) ...[
            _AreaCard(
              item: area,
              surfaceContainer: surfaceContainer,
              surfaceContainerHigh: surfaceContainerHigh,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SubjectsAreaScreen(
                      area: area.area,
                      surfaceContainer: surfaceContainer,
                      surfaceContainerHigh: surfaceContainerHigh,
                      onSurface: onSurface,
                      onSurfaceMuted: onSurfaceMuted,
                      primary: primary,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _AreaItem {
  const _AreaItem({
    required this.area,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  final SubjectsArea area;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
}

class _AreaCard extends StatelessWidget {
  const _AreaCard({
    required this.item,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onTap,
  });

  final _AreaItem item;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceContainer,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: surfaceContainerHigh),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: item.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: item.accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.manrope(
                        color: onSurface,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '40 questões',
                            style: GoogleFonts.plusJakartaSans(
                              color: onSurfaceMuted,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: item.accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Nível médio',
                            style: GoogleFonts.plusJakartaSans(
                              color: item.accent,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.chevron_right_rounded, color: onSurfaceMuted),
            ],
          ),
        ),
      ),
    );
  }
}
