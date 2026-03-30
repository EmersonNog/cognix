import 'package:flutter/material.dart';

enum SubjectsArea {
  natureza,
  humanas,
  linguagens,
  matematica,
}

class SubjectsAreaContent {
  const SubjectsAreaContent({
    required this.title,
    required this.items,
  });

  final String title;
  final List<SubjectItem> items;
}

class SubjectItem {
  const SubjectItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.footerText,
  });

  final String title;
  final String description;
  final IconData icon;
  final String footerText;
}

SubjectsAreaContent subjectsAreaContent(SubjectsArea area) {
  switch (area) {
    case SubjectsArea.natureza:
      return SubjectsAreaContent(
        title: 'Ciências da Natureza',
        items: [
          SubjectItem(
            title: 'Biologia',
            description: 'Citologia, Genética, Ecologia e Evolução das espécies.',
            icon: Icons.bubble_chart_rounded,
            footerText: '42 alunos matriculados',
          ),
          SubjectItem(
            title: 'Astronomia',
            description: 'Leis de Kepler, gravitação e modelos do universo.',
            icon: Icons.auto_awesome_rounded,
            footerText: '27 alunos matriculados',
          ),
        ],
      );
    case SubjectsArea.humanas:
      return SubjectsAreaContent(
        title: 'Ciências Humanas',
        items: [
          SubjectItem(
            title: 'Filosofia',
            description:
                'Ética, política, epistemologia e clássicos do pensamento.',
            icon: Icons.psychology_rounded,
            footerText: '33 alunos matriculados',
          ),
          SubjectItem(
            title: 'Sociologia',
            description:
                'Cultura, trabalho, estratificação e movimentos sociais.',
            icon: Icons.groups_rounded,
            footerText: '36 alunos matriculados',
          ),
        ],
      );
    case SubjectsArea.linguagens:
      return SubjectsAreaContent(
        title: 'Linguagens e Códigos',
        items: [
          SubjectItem(
            title: 'Inglês',
            description:
                'Compreensão textual, vocabulário e leitura estratégica.',
            icon: Icons.language_rounded,
            footerText: '40 alunos matriculados',
          ),
          SubjectItem(
            title: 'Artes',
            description:
                'História da arte, movimentos culturais e produção visual.',
            icon: Icons.palette_rounded,
            footerText: '22 alunos matriculados',
          ),
        ],
      );
    case SubjectsArea.matematica:
      return SubjectsAreaContent(
        title: 'Matemática',
        items: [
          SubjectItem(
            title: 'Estatística',
            description: 'Probabilidade, gráficos, análise de dados e médias.',
            icon: Icons.bar_chart_rounded,
            footerText: '31 alunos matriculados',
          ),
          SubjectItem(
            title: 'Raciocínio Lógico',
            description: 'Proposições, lógica matemática e argumentação.',
            icon: Icons.extension_rounded,
            footerText: '29 alunos matriculados',
          ),
        ],
      );
  }
}

String subjectsAreaTitle(SubjectsArea area) {
  return subjectsAreaContent(area).title;
}
