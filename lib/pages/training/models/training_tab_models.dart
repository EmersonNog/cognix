import 'package:flutter/material.dart';

import '../../subjects/subjects_data.dart';

class TrainingRhythmData {
  const TrainingRhythmData({
    required this.subtitle,
    required this.badgeLabel,
    required this.completedCountLabel,
  });

  const TrainingRhythmData.empty()
    : subtitle = 'Nenhum simulado iniciado ainda',
      badgeLabel = '0%',
      completedCountLabel = '0 simulados concluídos';

  final String subtitle;
  final String badgeLabel;
  final String completedCountLabel;
}

class TrainingAreaItem {
  const TrainingAreaItem({
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

const trainingAreas = [
  TrainingAreaItem(
    area: SubjectsArea.natureza,
    title: 'Ciências da Natureza e suas Tecnologias',
    subtitle: 'Física, Química e Biologia',
    icon: Icons.eco_rounded,
    accent: Color(0xFF7ED6C5),
  ),
  TrainingAreaItem(
    area: SubjectsArea.humanas,
    title: 'Ciências Humanas e suas Tecnologias',
    subtitle: 'História, Geografia e Sociologia',
    icon: Icons.public_rounded,
    accent: Color(0xFFF4A261),
  ),
  TrainingAreaItem(
    area: SubjectsArea.linguagens,
    title: 'Linguagens, Códigos e suas Tecnologias',
    subtitle: 'Português, Inglês e Artes',
    icon: Icons.record_voice_over_rounded,
    accent: Color(0xFF8AB6F9),
  ),
  TrainingAreaItem(
    area: SubjectsArea.matematica,
    title: 'Matemática e suas Tecnologias',
    subtitle: 'Álgebra, Geometria e Estatística',
    icon: Icons.calculate_rounded,
    accent: Color(0xFFE76F51),
  ),
];
