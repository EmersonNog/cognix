import 'package:flutter/material.dart';

import '../../../services/profile/profile_api.dart';

class HomeStreakCardViewState {
  const HomeStreakCardViewState({
    required this.headline,
    required this.description,
    required this.streakValue,
    required this.streakLabel,
    required this.badgeLabel,
    required this.highlightedBars,
    required this.icon,
    required this.accent,
    required this.frameColor,
    required this.badgeBackgroundColor,
    required this.badgeBorderColor,
  });

  final String headline;
  final String description;
  final String streakValue;
  final String streakLabel;
  final String badgeLabel;
  final int highlightedBars;
  final IconData icon;
  final Color accent;
  final Color frameColor;
  final Color badgeBackgroundColor;
  final Color badgeBorderColor;

  factory HomeStreakCardViewState.fromProfile(
    ProfileScoreData profile, {
    required bool isLoading,
  }) {
    if (isLoading) {
      return const HomeStreakCardViewState(
        headline: 'Carregando sua sequencia',
        description: 'Estamos calculando seus dias consecutivos de estudo.',
        streakValue: '--',
        streakLabel: 'Aguarde um instante',
        badgeLabel: 'AGORA',
        highlightedBars: 0,
        icon: Icons.local_fire_department_rounded,
        accent: Color(0xFFA3A6FF),
        frameColor: Color(0x1EA3A6FF),
        badgeBackgroundColor: Color(0x1FA3A6FF),
        badgeBorderColor: Color(0x33A3A6FF),
      );
    }

    final streakDays = profile.currentStreakDays;
    final activeDays = profile.activeDaysLast30;
    final lastActivityAt = profile.lastActivityAt;
    final daysSinceLastActivity = lastActivityAt == null
        ? null
        : DateUtils.dateOnly(
            DateTime.now(),
          ).difference(DateUtils.dateOnly(lastActivityAt)).inDays;

    if (streakDays > 0) {
      final badgeLabel = daysSinceLastActivity == 0 ? 'HOJE' : 'ATIVA';
      final description = daysSinceLastActivity == 0
          ? 'Voce ja estudou hoje e sua sequencia esta protegida.'
          : 'Seu ultimo registro foi ontem. Estude hoje para manter a sequencia.';

      return HomeStreakCardViewState(
        headline: 'Sequencia atual',
        description: description,
        streakValue: '$streakDays',
        streakLabel: streakDays == 1 ? 'dia seguido' : 'dias seguidos',
        badgeLabel: badgeLabel,
        highlightedBars: streakDays.clamp(0, 7),
        icon: Icons.local_fire_department_rounded,
        accent: const Color(0xFFA3A6FF),
        frameColor: const Color(0x24A3A6FF),
        badgeBackgroundColor: const Color(0x18A3A6FF),
        badgeBorderColor: const Color(0x38A3A6FF),
      );
    }

    if (activeDays > 0) {
      return const HomeStreakCardViewState(
        headline: 'Retome sua sequencia',
        description:
            'Sua sequencia nao esta ativa agora, mas voce pode reinicia-la ainda hoje.',
        streakValue: '0',
        streakLabel: 'dias em sequencia',
        badgeLabel: 'VOLTE',
        highlightedBars: 0,
        icon: Icons.bolt_rounded,
        accent: Color(0xFF7ED6C5),
        frameColor: Color(0x247ED6C5),
        badgeBackgroundColor: Color(0x1B7ED6C5),
        badgeBorderColor: Color(0x387ED6C5),
      );
    }

    return const HomeStreakCardViewState(
      headline: 'Comece sua sequencia',
      description:
          'Responda questoes ou conclua um simulado para iniciar sua rotina.',
      streakValue: '0',
      streakLabel: 'dias em sequencia',
      badgeLabel: 'NOVO',
      highlightedBars: 0,
      icon: Icons.rocket_launch_rounded,
      accent: Color(0xFFA3A6FF),
      frameColor: Color(0x1EA3A6FF),
      badgeBackgroundColor: Color(0x1AA3A6FF),
      badgeBorderColor: Color(0x33A3A6FF),
    );
  }
}
