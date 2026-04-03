import 'package:flutter/material.dart';

class ProfileHeaderMomentumViewData {
  const ProfileHeaderMomentumViewData({
    required this.label,
    required this.description,
    required this.index,
    this.indexLabel,
    required this.accent,
  });

  final String label;
  final String description;
  final int index;
  final String? indexLabel;
  final Color accent;
}

ProfileHeaderMomentumViewData buildProfileHeaderMomentumView({
  required double exactMomentumScore,
  required int completedSessions,
}) {
  final normalizedMomentum = exactMomentumScore.clamp(-10.0, 10.0).toDouble();
  final index = (((normalizedMomentum + 10.0) / 20.0) * 100.0).round();

  if (completedSessions <= 0) {
    return const ProfileHeaderMomentumViewData(
      label: 'Come\u00e7ando agora',
      description:
          'Seu \u00edndice come\u00e7a em 0 e passa a reagir depois do primeiro simulado conclu\u00eddo.',
      index: 0,
      indexLabel: '0/100',
      accent: Color(0xFF8E96B8),
    );
  }

  if (index >= 80) {
    return ProfileHeaderMomentumViewData(
      label: 'Em boa sequ\u00eancia',
      description:
          'Seu ritmo est\u00e1 forte agora. Vale aproveitar essa fase para manter o embalo.',
      index: index,
      accent: const Color.fromARGB(255, 38, 208, 120),
    );
  }

  if (index >= 65) {
    return ProfileHeaderMomentumViewData(
      label: 'Ganhando tra\u00e7\u00e3o',
      description:
          'Seu momento est\u00e1 melhorando. Mais alguns bons blocos podem elevar esse \u00edndice.',
      index: index,
      accent: const Color.fromARGB(255, 28, 191, 251),
    );
  }

  if (index >= 50) {
    return ProfileHeaderMomentumViewData(
      label: 'Ritmo est\u00e1vel',
      description:
          'Seu estudo est\u00e1 equilibrado. Consist\u00eancia e boas respostas ajudam a subir esse term\u00f4metro.',
      index: index,
      accent: const Color(0xFF8E7CFF),
    );
  }

  if (index >= 35) {
    return ProfileHeaderMomentumViewData(
      label: 'Ritmo inst\u00e1vel',
      description:
          'Seu desempenho recente oscila. Um pouco mais de const\u00e2ncia j\u00e1 tende a firmar o seu ritmo.',
      index: index,
      accent: const Color(0xFFFFC857),
    );
  }

  return ProfileHeaderMomentumViewData(
    label: 'Hora de retomar',
    description:
        'Seu ritmo esfriou nos \u00faltimos dias. Uma nova sess\u00e3o bem feita j\u00e1 pode reacender esse momento.',
    index: index,
    accent: const Color(0xFFFF8B7A),
  );
}

String buildProfileHeaderNextLevelMessage({
  required String? nextLevel,
  required int pointsToNextLevel,
}) {
  if (nextLevel == null) {
    return 'Voc\u00ea j\u00e1 alcan\u00e7ou o n\u00edvel m\u00e1ximo. Parab\u00e9ns!';
  }
  if (pointsToNextLevel <= 0) {
    return 'Quase l\u00e1: complete mais uma a\u00e7\u00e3o para subir de n\u00edvel.';
  }
  return 'Faltam $pointsToNextLevel pontos para o seu pr\u00f3ximo salto!';
}

Color profileHeaderLevelAccent(String level, Color fallback) {
  switch (_normalizeLevel(level)) {
    case 'iniciante':
      return const Color(0xFF68A8FF);
    case 'em evolucao':
      return const Color(0xFF45D0C2);
    case 'dedicado':
      return const Color(0xFF8E7CFF);
    case 'avancado':
      return const Color(0xFFFFC857);
    case 'academico avancado':
      return const Color(0xFFFF9E5E);
    default:
      return fallback;
  }
}

String profileHeaderLevelEmoji(String level) {
  switch (_normalizeLevel(level)) {
    case 'iniciante':
      return '\u{1F331}';
    case 'em evolucao':
      return '\u{1F680}';
    case 'dedicado':
      return '\u{1F4D8}';
    case 'avancado':
      return '\u{1F3C6}';
    case 'academico avancado':
      return '\u{1F451}';
    default:
      return '\u{2B50}';
  }
}

String profileHeaderDisplayLevel(String level) {
  switch (_normalizeLevel(level)) {
    case 'iniciante':
      return 'Iniciante';
    case 'em evolucao':
      return 'Em evolu\u00e7\u00e3o';
    case 'dedicado':
      return 'Dedicado';
    case 'avancado':
      return 'Avan\u00e7ado';
    case 'academico avancado':
      return 'Acad\u00eamico avan\u00e7ado';
    default:
      return level;
  }
}

String _normalizeLevel(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll('\u00e1', 'a')
      .replaceAll('\u00e2', 'a')
      .replaceAll('\u00e3', 'a')
      .replaceAll('\u00e7', 'c')
      .replaceAll('\u00e9', 'e')
      .replaceAll('\u00ea', 'e')
      .replaceAll('\u00ed', 'i')
      .replaceAll('\u00f3', 'o')
      .replaceAll('\u00f4', 'o')
      .replaceAll('\u00f5', 'o')
      .replaceAll('\u00fa', 'u')
      .replaceAll('Ã¡', 'a')
      .replaceAll('Ã¢', 'a')
      .replaceAll('Ã£', 'a')
      .replaceAll('Ã§', 'c')
      .replaceAll('Ã©', 'e')
      .replaceAll('Ãª', 'e')
      .replaceAll('Ã­', 'i')
      .replaceAll('Ã³', 'o')
      .replaceAll('Ã´', 'o')
      .replaceAll('Ãµ', 'o')
      .replaceAll('Ãº', 'u');
}
