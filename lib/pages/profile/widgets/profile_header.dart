import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../services/profile/profile_api.dart';
import '../../../theme/cognix_theme_colors.dart';
import '../avatar_store_dialog.dart';
import 'profile_header_summary_card.dart';
import 'profile_header_utils.dart';
import 'profile_stats_box.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
    required this.userName,
    required this.level,
    required this.score,
    required this.exactScore,
    required this.coinsBalance,
    required this.equippedAvatarSeed,
    required this.avatarStore,
    required this.recentIndex,
    required this.recentIndexReady,
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
    required this.onRefreshProfile,
    this.previewMode = false,
    this.onLockedTap,
  });

  final String userName;
  final String level;
  final int score;
  final double exactScore;
  final double coinsBalance;
  final String equippedAvatarSeed;
  final List<ProfileAvatarStoreItem> avatarStore;
  final int recentIndex;
  final bool recentIndexReady;
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
  final Future<void> Function() onRefreshProfile;
  final bool previewMode;
  final VoidCallback? onLockedTap;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  void _openAvatarSelector() {
    if (widget.previewMode) {
      widget.onLockedTap?.call();
      return;
    }

    final colors = context.cognixColors;
    showGeneralDialog<Object?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Avatar store',
      barrierColor: colors.surfaceLow.withValues(alpha: 0.24),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SizedBox.expand(
            child: AvatarSelectorDialog(
              primary: widget.primary,
              onSurface: widget.onSurface,
              surfaceContainer: widget.surfaceContainer,
              coinsBalance: widget.coinsBalance,
              equippedAvatarSeed: widget.equippedAvatarSeed,
              avatarStore: widget.avatarStore,
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final scale = Tween<double>(begin: 0.92, end: 1).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
            reverseCurve: Curves.easeInCubic,
          ),
        );
        final slide =
            Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            );

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(scale: scale, child: child),
          ),
        );
      },
    ).then((updated) async {
      if (updated == true && mounted) {
        await widget.onRefreshProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelAccent = profileHeaderLevelAccent(
      widget.previewMode ? 'dedicado' : widget.level,
      widget.primary,
    );
    final levelEmoji = widget.previewMode
        ? ''
        : profileHeaderLevelEmoji(widget.level);
    final displayedLevel = widget.previewMode
        ? 'Acesso premium'
        : profileHeaderDisplayLevel(widget.level);
    final recentIndexView = widget.previewMode
        ? ProfileHeaderRecentIndexViewData(
            label: 'Disponível com assinatura',
            description:
                'Desbloqueie o painel para acompanhar seu índice recente, entender seu momento e ajustar o ritmo de estudo.',
            index: 0,
            isLocked: true,
            accent: widget.primary,
          )
        : buildProfileHeaderRecentIndexView(
            recentIndex: widget.recentIndex,
            recentIndexReady: widget.recentIndexReady,
          );
    final coinsLabel = widget.previewMode
        ? 'PREMIUM'
        : formatCoinsLabel(widget.coinsBalance);
    final nextLevelMessage = widget.previewMode
        ? 'Desbloqueie score, frequência e progresso para acompanhar sua evolução com mais clareza.'
        : buildProfileHeaderNextLevelMessage(
            nextLevel: widget.nextLevel,
            pointsToNextLevel: widget.pointsToNextLevel,
          );
    final scoreLabel = widget.previewMode
        ? ''
        : widget.exactScore > 0
        ? widget.exactScore.toStringAsFixed(1)
        : widget.score.toString();

    return Column(
      children: <Widget>[
        ProfileHeaderSummaryCard(
          userName: widget.userName,
          displayedLevel: displayedLevel,
          levelAccent: levelAccent,
          levelEmoji: levelEmoji,
          scoreLabel: scoreLabel,
          coinsLabel: coinsLabel,
          avatarSeed: widget.equippedAvatarSeed,
          activeDaysLast30: widget.previewMode ? 0 : widget.activeDaysLast30,
          consistencyWindowDays: widget.consistencyWindowDays,
          completedSessions: widget.previewMode ? 0 : widget.completedSessions,
          nextLevelMessage: nextLevelMessage,
          recentIndexView: recentIndexView,
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primaryDim: widget.primaryDim,
          onAvatarTap: _openAvatarSelector,
          previewMode: widget.previewMode,
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            ProfileStatsBox(
              value: widget.previewMode ? '' : widget.questionsCount,
              label: 'QUESTÕES',
              icon: Icons.quiz_rounded,
              surfaceContainer: widget.surfaceContainer,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
              previewMode: widget.previewMode,
            ),
            const SizedBox(width: 12),
            ProfileStatsBox(
              value: widget.previewMode ? '' : widget.studyHoursLabel,
              label: 'TEMPO',
              icon: Icons.schedule_rounded,
              surfaceContainer: widget.surfaceContainer,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
              previewMode: widget.previewMode,
            ),
            const SizedBox(width: 12),
            ProfileStatsBox(
              value: widget.previewMode ? '' : widget.accuracyLabel,
              label: 'PRECISÃO',
              icon: Icons.track_changes_rounded,
              surfaceContainer: widget.surfaceContainer,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
              previewMode: widget.previewMode,
            ),
          ],
        ),
      ],
    );
  }
}
