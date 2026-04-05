import 'package:flutter/material.dart';

import '../../../../services/profile/profile_api.dart';

class HomeStreakCardViewState {
  const HomeStreakCardViewState({
    required this.headline,
    required this.description,
    required this.streakValue,
    required this.streakLabel,
    required this.badgeLabel,
    required this.recentActivityWindow,
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
  final List<ProfileRecentActivityDay> recentActivityWindow;
  final IconData icon;
  final Color accent;
  final Color frameColor;
  final Color badgeBackgroundColor;
  final Color badgeBorderColor;

  factory HomeStreakCardViewState.fromProfile(
    ProfileScoreData profile, {
    required bool isLoading,
  }) {
    final fallbackWindow = _buildFallbackRecentActivityWindow();
    final recentActivityWindow = profile.recentActivityWindow.isEmpty
        ? fallbackWindow
        : profile.recentActivityWindow;

    if (isLoading) {
      return HomeStreakCardViewState(
        headline: 'Carregando sua sequência',
        description: 'Estamos calculando seus dias consecutivos de estudo.',
        streakValue: '--',
        streakLabel: 'Aguarde um instante',
        badgeLabel: 'AGORA',
        recentActivityWindow: fallbackWindow,
        icon: Icons.local_fire_department_rounded,
        accent: const Color(0xFFA3A6FF),
        frameColor: const Color(0x1EA3A6FF),
        badgeBackgroundColor: const Color(0x1FA3A6FF),
        badgeBorderColor: const Color(0x33A3A6FF),
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
          ? 'Você já estudou hoje e sua sequência está protegida.'
          : 'Seu último registro foi ontem. Estude hoje para manter a sequência.';

      return HomeStreakCardViewState(
        headline: 'Sequencia atual',
        description: description,
        streakValue: '$streakDays',
        streakLabel: streakDays == 1 ? 'dia seguido' : 'dias seguidos',
        badgeLabel: badgeLabel,
        recentActivityWindow: recentActivityWindow,
        icon: Icons.local_fire_department_rounded,
        accent: const Color(0xFFA3A6FF),
        frameColor: const Color(0x24A3A6FF),
        badgeBackgroundColor: const Color(0x18A3A6FF),
        badgeBorderColor: const Color(0x38A3A6FF),
      );
    }

    if (activeDays > 0) {
      return HomeStreakCardViewState(
        headline: 'Retome sua sequência',
        description:
            'Sua sequência não está ativa agora, mas você pode reiniciá-la ainda hoje.',
        streakValue: '0',
        streakLabel: 'dias em sequência',
        badgeLabel: 'VOLTE',
        recentActivityWindow: recentActivityWindow,
        icon: Icons.bolt_rounded,
        accent: const Color(0xFF7ED6C5),
        frameColor: const Color(0x247ED6C5),
        badgeBackgroundColor: const Color(0x1B7ED6C5),
        badgeBorderColor: const Color(0x387ED6C5),
      );
    }

    return HomeStreakCardViewState(
      headline: 'Comece sua sequência',
      description:
          'Responda questões ou conclua um simulado para iniciar sua rotina.',
      streakValue: '0',
      streakLabel: 'dias em sequência',
      badgeLabel: 'NOVO',
      recentActivityWindow: recentActivityWindow,
      icon: Icons.rocket_launch_rounded,
      accent: const Color(0xFFA3A6FF),
      frameColor: const Color(0x1EA3A6FF),
      badgeBackgroundColor: const Color(0x1AA3A6FF),
      badgeBorderColor: const Color(0x33A3A6FF),
    );
  }

  static List<ProfileRecentActivityDay> _buildFallbackRecentActivityWindow() {
    final today = DateUtils.dateOnly(DateTime.now());
    final start = today.subtract(const Duration(days: 6));

    return List<ProfileRecentActivityDay>.generate(7, (index) {
      final date = start.add(Duration(days: index));
      return ProfileRecentActivityDay(
        date: date,
        active: false,
        isToday: DateUtils.isSameDay(date, today),
      );
    });
  }
}
