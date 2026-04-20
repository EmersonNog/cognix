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
    required Color primary,
    required Color success,
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
        accent: primary,
        frameColor: primary.withValues(alpha: 0.12),
        badgeBackgroundColor: primary.withValues(alpha: 0.13),
        badgeBorderColor: primary.withValues(alpha: 0.2),
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
        headline: 'Sequência atual',
        description: description,
        streakValue: '$streakDays',
        streakLabel: streakDays == 1 ? 'dia seguido' : 'dias seguidos',
        badgeLabel: badgeLabel,
        recentActivityWindow: recentActivityWindow,
        icon: Icons.local_fire_department_rounded,
        accent: primary,
        frameColor: primary.withValues(alpha: 0.14),
        badgeBackgroundColor: primary.withValues(alpha: 0.1),
        badgeBorderColor: primary.withValues(alpha: 0.22),
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
        accent: success,
        frameColor: success.withValues(alpha: 0.14),
        badgeBackgroundColor: success.withValues(alpha: 0.1),
        badgeBorderColor: success.withValues(alpha: 0.22),
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
      accent: primary,
      frameColor: primary.withValues(alpha: 0.12),
      badgeBackgroundColor: primary.withValues(alpha: 0.1),
      badgeBorderColor: primary.withValues(alpha: 0.2),
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
