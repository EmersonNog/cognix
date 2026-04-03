import 'package:flutter/material.dart';

import '../../subjects/subjects_data.dart';

class TrainingRhythmData {
  const TrainingRhythmData({
    required this.subtitle,
    required this.badgeLabel,
    required this.completedCountLabel,
    this.isLoading = false,
    this.isError = false,
  });

  const TrainingRhythmData.empty()
    : subtitle = 'Nenhum simulado iniciado ainda',
      badgeLabel = '0%',
      completedCountLabel = '0 simulados conclu\u00eddos',
      isLoading = false,
      isError = false;

  const TrainingRhythmData.loading()
    : subtitle = 'Carregando seu ritmo de treino',
      badgeLabel = '...',
      completedCountLabel = 'Buscando seu hist\u00f3rico recente',
      isLoading = true,
      isError = false;

  const TrainingRhythmData.error()
    : subtitle = 'N\u00e3o foi poss\u00edvel carregar agora',
      badgeLabel = '--',
      completedCountLabel = 'Puxe para atualizar',
      isLoading = false,
      isError = true;

  final String subtitle;
  final String badgeLabel;
  final String completedCountLabel;
  final bool isLoading;
  final bool isError;
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
    title: 'Ci\u00eancias da Natureza e suas Tecnologias',
    subtitle: 'F\u00edsica, Qu\u00edmica e Biologia',
    icon: Icons.eco_rounded,
    accent: Color(0xFF7ED6C5),
  ),
  TrainingAreaItem(
    area: SubjectsArea.humanas,
    title: 'Ci\u00eancias Humanas e suas Tecnologias',
    subtitle: 'Hist\u00f3ria, Geografia e Sociologia',
    icon: Icons.public_rounded,
    accent: Color(0xFFF4A261),
  ),
  TrainingAreaItem(
    area: SubjectsArea.linguagens,
    title: 'Linguagens, C\u00f3digos e suas Tecnologias',
    subtitle: 'Portugu\u00eas, Ingl\u00eas e Artes',
    icon: Icons.record_voice_over_rounded,
    accent: Color(0xFF8AB6F9),
  ),
  TrainingAreaItem(
    area: SubjectsArea.matematica,
    title: 'Matem\u00e1tica e suas Tecnologias',
    subtitle: '\u00c1lgebra, Geometria e Estat\u00edstica',
    icon: Icons.calculate_rounded,
    accent: Color(0xFFE76F51),
  ),
];
