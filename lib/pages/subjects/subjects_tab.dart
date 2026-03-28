import 'package:flutter/material.dart';
import 'widgets/subject_card.dart';
import 'widgets/subject_category_header.dart';
import 'widgets/subject_compact_card.dart';
import 'widgets/subjects_hero_card.dart';

class SubjectsTab extends StatelessWidget {
  const SubjectsTab({
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        SubjectsHeroCard(
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 20),
        SubjectCategoryHeader(
          title: 'Ciências Exatas',
          subtitle: '4 Matérias Disponíveis',
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 14),
        SubjectCard(
          title: 'Física',
          description: 'Mecânica, Termodinâmica, Óptica e Eletromagnetismo.',
          progress: 0.65,
          progressLabel: '65% Concluído',
          icon: Icons.science_rounded,
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 12),
        SubjectCard(
          title: 'Matemática',
          description: 'Funções, Geometria, Análise Combinatória e Probabilidade.',
          progress: 0.42,
          progressLabel: '42% Concluído',
          icon: Icons.calculate_rounded,
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 12),
        SubjectCard(
          title: 'Química',
          description: 'Atomística, Química Orgânica, Estequiometria e Termoquímica.',
          progress: 0.28,
          progressLabel: '28% Concluído',
          icon: Icons.biotech_rounded,
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 12),
        SubjectCard(
          title: 'Tecnologia',
          description: 'Lógica de Programação, Algoritmos e Cultura Digital.',
          progress: 0.51,
          progressLabel: '51% Concluído',
          icon: Icons.memory_rounded,
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 18),
        SubjectCategoryHeader(
          title: 'Ciências Humanas',
          subtitle: '3 Matérias Disponíveis',
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 14),
        SubjectCompactCard(
          title: 'Literatura',
          description: 'Escolas Literárias, Análise de Obras e Interpretação.',
          icon: Icons.menu_book_rounded,
          footerText: '54 alunos matriculados',
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 12),
        SubjectCompactCard(
          title: 'Filosofia e Sociologia',
          description: 'Ética, Política, Correntes de Pensamento e Cultura.',
          icon: Icons.psychology_rounded,
          footerText: '40 alunos matriculados',
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 12),
        SubjectCompactCard(
          title: 'História',
          description: 'Brasil Colônia e Império, Revoluções e Guerras Mundiais.',
          icon: Icons.public_rounded,
          footerText: '45 alunos matriculados',
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 18),
        SubjectCategoryHeader(
          title: 'Ciências Biológicas',
          subtitle: '2 Matérias Disponíveis',
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 14),
        SubjectCompactCard(
          title: 'Biologia Celular',
          description:
              'DNA, Replicação, Síntese de Proteínas e Genética Mendeliana.',
          icon: Icons.bubble_chart_rounded,
          footerText: '38 alunos matriculados',
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 12),
        SubjectCompactCard(
          title: 'Fisiologia Humana',
          description:
              'Sistemas do corpo humano, Homeostase e Anatomia aplicada.',
          icon: Icons.favorite_rounded,
          footerText: '29 alunos matriculados',
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
      ],
    );
  }
}
