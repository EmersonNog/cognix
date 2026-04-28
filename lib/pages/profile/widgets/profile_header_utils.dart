import 'package:flutter/material.dart';

class ProfileHeaderRecentIndexViewData {
  const ProfileHeaderRecentIndexViewData({
    required this.label,
    required this.description,
    required this.index,
    this.indexLabel,
    this.isLocked = false,
    required this.accent,
  });

  final String label;
  final String description;
  final int index;
  final String? indexLabel;
  final bool isLocked;
  final Color accent;
}

ProfileHeaderRecentIndexViewData buildProfileHeaderRecentIndexView({
  required int recentIndex,
  required bool recentIndexReady,
}) {
  final index = recentIndex.clamp(0, 100);

  if (!recentIndexReady) {
    return const ProfileHeaderRecentIndexViewData(
      label: 'Começando agora',
      description:
          'Seu índice começa em 0 e passa a reagir conforme suas respostas e sessões recentes.',
      index: 0,
      indexLabel: '0/100',
      accent: Color(0xFF8E96B8),
    );
  }

  if (index >= 80) {
    return ProfileHeaderRecentIndexViewData(
      label: 'Em boa sequência',
      description:
          'Seu ritmo está forte agora. Vale aproveitar essa fase para manter o embalo.',
      index: index,
      accent: const Color.fromARGB(255, 38, 208, 120),
    );
  }

  if (index >= 65) {
    return ProfileHeaderRecentIndexViewData(
      label: 'Ganhando tração',
      description:
          'Seu momento está melhorando. Mais alguns bons blocos podem elevar esse índice.',
      index: index,
      accent: const Color.fromARGB(255, 28, 191, 251),
    );
  }

  if (index >= 50) {
    return ProfileHeaderRecentIndexViewData(
      label: 'Ritmo estável',
      description:
          'Seu estudo está equilibrado. Consistência e boas respostas ajudam a subir esse termômetro.',
      index: index,
      accent: const Color(0xFF8E7CFF),
    );
  }

  if (index >= 35) {
    return ProfileHeaderRecentIndexViewData(
      label: 'Ritmo instável',
      description:
          'Seu desempenho recente oscila. Um pouco mais de constência já tende a firmar o seu ritmo.',
      index: index,
      accent: const Color(0xFFFFC857),
    );
  }

  return ProfileHeaderRecentIndexViewData(
    label: 'Hora de retomar',
    description:
        'Seu ritmo esfriou nos últimos dias. Uma nova sessão bem feita já pode reacender esse momento.',
    index: index,
    accent: const Color(0xFFFF8B7A),
  );
}

String buildProfileHeaderNextLevelMessage({
  required String? nextLevel,
  required int pointsToNextLevel,
}) {
  if (nextLevel == null) {
    return 'Você já alcançou o nível máximo. Parabéns!';
  }
  if (pointsToNextLevel <= 0) {
    return 'Quase lá: complete mais uma ação para subir de nível.';
  }
  return 'Faltam $pointsToNextLevel pontos para o seu próximo salto!';
}

String formatCoinsLabel(double coins) {
  final normalized = coins < 0 ? 0.0 : coins;
  final scaled = (normalized * 10).round();
  final hasFraction = scaled % 10 != 0;
  return hasFraction
      ? '${normalized.toStringAsFixed(1)} 🪙'
      : '${normalized.toStringAsFixed(0)} 🪙';
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
      return '🌱';
    case 'em evolucao':
      return '🚀';
    case 'dedicado':
      return '📘';
    case 'avancado':
      return '🏆';
    case 'academico avancado':
      return '👑';
    default:
      return '⭐';
  }
}

String profileHeaderDisplayLevel(String level) {
  switch (_normalizeLevel(level)) {
    case 'iniciante':
      return 'Iniciante';
    case 'em evolucao':
      return 'Em evolução';
    case 'dedicado':
      return 'Dedicado';
    case 'avancado':
      return 'Avançado';
    case 'academico avancado':
      return 'Acadêmico avançado';
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
