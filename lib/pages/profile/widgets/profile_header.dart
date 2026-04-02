import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'avatar_selector_dialog.dart';
import 'profile_avatar_display.dart';
import 'profile_stats_box.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
    required this.userName,
    required this.level,
    required this.score,
    required this.exactScore,
    required this.questionsCount,
    required this.studyHoursLabel,
    required this.accuracyLabel,
    required this.completedSessions,
    required this.activeDaysLast30,
    required this.consistencyWindowDays,
    required this.nextLevel,
    required this.pointsToNextLevel,
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
  });

  final String userName;
  final String level;
  final int score;
  final double exactScore;
  final String questionsCount;
  final String studyHoursLabel;
  final String accuracyLabel;
  final int completedSessions;
  final int activeDaysLast30;
  final int consistencyWindowDays;
  final String? nextLevel;
  final int pointsToNextLevel;
  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  void _openAvatarSelector() {
    showDialog(
      context: context,
      builder: (context) => AvatarSelectorDialog(
        primary: widget.primary,
        onSurface: widget.onSurface,
        surfaceContainer: widget.surfaceContainer,
      ),
    ).then((newSeed) {
      if (newSeed != null) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelAccent = _levelAccent(widget.level);
    final levelEmoji = _levelEmoji(widget.level);
      final nextLevelMessage = widget.nextLevel == null
        ? 'Você já alcançou o nível máximo, parabéns!'
        : widget.pointsToNextLevel <= 0
        ? 'Quase lá: complete mais uma ação para subir de nível.'
        : 'Faltam ${widget.pointsToNextLevel} pontos para o seu próximo salto!';
      final scoreLabel = widget.exactScore > 0
          ? widget.exactScore.toStringAsFixed(1)
          : widget.score.toString();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2A275A),
                Color.lerp(widget.primaryDim, levelAccent, 0.35)!.withOpacity(
                  0.28,
                ),
                const Color(0xFF121B35),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.32),
                blurRadius: 30,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileAvatarDisplay(
                    userName: widget.userName,
                    primary: levelAccent,
                    size: 92,
                    onTap: _openAvatarSelector,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: levelAccent.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: levelAccent.withOpacity(0.24),
                            ),
                          ),
                          child: Text(
                            '$levelEmoji ${widget.level.toUpperCase()}',
                            style: GoogleFonts.plusJakartaSans(
                              color: levelAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.userName,
                          style: GoogleFonts.manrope(
                            color: widget.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nível definido por questões, precisão, simulados concluídos e consistência diária.',
                          style: GoogleFonts.inter(
                            color: widget.onSurfaceMuted,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _MetricPill(
                      label: 'Score',
                      value: '$scoreLabel/100',
                      accent: levelAccent,
                      onSurface: widget.onSurface,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricPill(
                      label: 'Consistência',
                      value:
                          '${widget.activeDaysLast30}/${widget.consistencyWindowDays} dias',
                      accent: levelAccent,
                      onSurface: widget.onSurface,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricPill(
                      label: 'Simulados',
                      value: widget.completedSessions.toString(),
                      accent: levelAccent,
                      onSurface: widget.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2140).withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.03)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: widget.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        nextLevelMessage,
                        style: GoogleFonts.inter(
                          color: widget.onSurface,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            ProfileStatsBox(
              value: widget.questionsCount,
              label: 'QUESTÕES',
              icon: Icons.quiz_rounded,
              surfaceContainer: widget.surfaceContainer,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
            ),
            const SizedBox(width: 12),
            ProfileStatsBox(
              value: widget.studyHoursLabel,
              label: 'TEMPO',
              icon: Icons.schedule_rounded,
              surfaceContainer: widget.surfaceContainer,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
            ),
            const SizedBox(width: 12),
            ProfileStatsBox(
              value: widget.accuracyLabel,
              label: 'PRECISÃO',
              icon: Icons.track_changes_rounded,
              surfaceContainer: widget.surfaceContainer,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
            ),
          ],
        ),
      ],
    );
  }

  Color _levelAccent(String level) {
    switch (level.trim().toLowerCase()) {
      case 'iniciante':
        return const Color(0xFF68A8FF);
      case 'em evolucao':
      case 'em evolução':
        return const Color(0xFF45D0C2);
      case 'dedicado':
        return const Color(0xFF8E7CFF);
      case 'avancado':
      case 'avançado':
        return const Color(0xFFFFC857);
      case 'academico avancado':
      case 'acadêmico avançado':
        return const Color(0xFFFF9E5E);
      default:
        return widget.primary;
    }
  }

  String _levelEmoji(String level) {
    switch (level.trim().toLowerCase()) {
      case 'iniciante':
        return '🌱';
      case 'em evolucao':
      case 'em evolução':
        return '🚀';
      case 'dedicado':
        return '📘';
      case 'avancado':
      case 'avançado':
        return '🏆';
      case 'academico avancado':
      case 'acadêmico avançado':
        return '👑';
      default:
        return '⭐';
    }
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.value,
    required this.accent,
    required this.onSurface,
  });

  final String label;
  final String value;
  final Color accent;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.visible,
            softWrap: false,
            style: GoogleFonts.plusJakartaSans(
              color: accent,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
