import 'package:flutter/material.dart';

import '../../../services/profile/profile_api.dart';

class HomeStreakCardViewState {
  const HomeStreakCardViewState({
    required this.headline,
    required this.description,
    required this.streakValue,
    required this.streakLabel,
    required this.badgeLabel,
    required this.footerLabel,
    required this.highlightedBars,
    required this.icon,
    required this.accent,
    required this.frameColor,
    required this.badgeBackgroundColor,
    required this.badgeBorderColor,
    required this.footerBackgroundColor,
    required this.footerBorderColor,
  });

  final String headline;
  final String description;
  final String streakValue;
  final String streakLabel;
  final String badgeLabel;
  final String footerLabel;
  final int highlightedBars;
  final IconData icon;
  final Color accent;
  final Color frameColor;
  final Color badgeBackgroundColor;
  final Color badgeBorderColor;
  final Color footerBackgroundColor;
  final Color footerBorderColor;

  factory HomeStreakCardViewState.fromProfile(
    ProfileScoreData profile, {
    required bool isLoading,
  }) {
    if (isLoading) {
      return const HomeStreakCardViewState(
        headline: 'Carregando sua sequência',
        description: 'Estamos calculando seus dias consecutivos de estudo.',
        streakValue: '--',
        streakLabel: 'Aguarde um instante',
        badgeLabel: 'AGORA',
        footerLabel: 'Atualizando seu histórico de atividade.',
        highlightedBars: 0,
        icon: Icons.local_fire_department_rounded,
        accent: Color(0xFFA3A6FF),
        frameColor: Color(0x1EA3A6FF),
        badgeBackgroundColor: Color(0x1FA3A6FF),
        badgeBorderColor: Color(0x33A3A6FF),
        footerBackgroundColor: Color(0x141A2748),
        footerBorderColor: Color(0x20A3A6FF),
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
          ? 'Você já estudou hoje e sua sequência segue protegida.'
          : 'Seu último registro foi ontem. Estude hoje para manter a chama acesa.';

      return HomeStreakCardViewState(
        headline: 'Seu ritmo de estudos',
        description: description,
        streakValue: '$streakDays',
        streakLabel: streakDays == 1 ? 'dia seguido' : 'dias seguidos',
        badgeLabel: badgeLabel,
        footerLabel: _activeDaysFooterLabel(activeDays),
        highlightedBars: streakDays.clamp(0, 7),
        icon: Icons.local_fire_department_rounded,
        accent: const Color(0xFFA3A6FF),
        frameColor: const Color(0x24A3A6FF),
        badgeBackgroundColor: const Color(0x18A3A6FF),
        badgeBorderColor: const Color(0x38A3A6FF),
        footerBackgroundColor: const Color(0x141A2748),
        footerBorderColor: const Color(0x20A3A6FF),
      );
    }

    if (activeDays > 0) {
      return HomeStreakCardViewState(
        headline: 'Hora de retomar',
        description:
            'Sua sequência não está ativa no momento, mas você pode reiniciá-la ainda hoje.',
        streakValue: '0',
        streakLabel: 'dias em sequência',
        badgeLabel: 'VOLTE',
        footerLabel: _activeDaysFooterLabel(activeDays),
        highlightedBars: 0,
        icon: Icons.bolt_rounded,
        accent: const Color(0xFF7ED6C5),
        frameColor: const Color(0x247ED6C5),
        badgeBackgroundColor: const Color(0x1B7ED6C5),
        badgeBorderColor: const Color(0x387ED6C5),
        footerBackgroundColor: const Color(0x137ED6C5),
        footerBorderColor: const Color(0x247ED6C5),
      );
    }

    return const HomeStreakCardViewState(
      headline: 'Comece sua primeira sequência',
      description:
          'Responda questões ou conclua um simulado para iniciar sua rotina.',
      streakValue: '0',
      streakLabel: 'dias em sequência',
      badgeLabel: 'NOVO',
      footerLabel: 'Seu histórico vai aparecer aqui conforme você pratica.',
      highlightedBars: 0,
      icon: Icons.rocket_launch_rounded,
      accent: Color(0xFFA3A6FF),
      frameColor: Color(0x1EA3A6FF),
      badgeBackgroundColor: Color(0x1AA3A6FF),
      badgeBorderColor: Color(0x33A3A6FF),
      footerBackgroundColor: Color(0x141A2748),
      footerBorderColor: Color(0x20A3A6FF),
    );
  }

  static String _activeDaysFooterLabel(int activeDays) {
    if (activeDays == 1) {
      return '1 dia ativo nos últimos 30 dias.';
    }
    return '$activeDays dias ativos nos últimos 30 dias.';
  }
}
