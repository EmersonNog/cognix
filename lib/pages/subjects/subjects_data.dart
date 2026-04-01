import 'package:flutter/material.dart';

enum SubjectsArea { natureza, humanas, linguagens, matematica }

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

String subjectsAreaTitle(SubjectsArea area) {
  switch (area) {
    case SubjectsArea.natureza:
      return 'Ciências da Natureza e suas Tecnologias';
    case SubjectsArea.humanas:
      return 'Ciências Humanas e suas Tecnologias';
    case SubjectsArea.linguagens:
      return 'Linguagens, Códigos e suas Tecnologias';
    case SubjectsArea.matematica:
      return 'Matemática e suas Tecnologias';
  }
}

SubjectsArea? subjectsAreaFromTitle(String title) {
  final value = title.toLowerCase();
  if (value.contains('natureza')) {
    return SubjectsArea.natureza;
  }
  if (value.contains('humanas')) {
    return SubjectsArea.humanas;
  }
  if (value.contains('linguagens')) {
    return SubjectsArea.linguagens;
  }
  if (value.contains('matemat')) {
    return SubjectsArea.matematica;
  }
  return null;
}
