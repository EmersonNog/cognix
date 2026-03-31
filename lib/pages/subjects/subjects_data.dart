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
      return 'Ciências da natureza e suas tecnologias';
    case SubjectsArea.humanas:
      return 'Ciências humanas e suas tecnologias';
    case SubjectsArea.linguagens:
      return 'Linguagens, códigos e suas tecnologias';
    case SubjectsArea.matematica:
      return 'Matemática e suas tecnologias';
  }
}
