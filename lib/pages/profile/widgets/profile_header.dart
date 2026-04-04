import 'package:flutter/material.dart';

import 'avatar_selector_dialog.dart';
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
  });

  final String userName;
  final String level;
  final int score;
  final double exactScore;
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

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  void _openAvatarSelector() {
    showDialog<Object?>(
      context: context,
      builder: (context) => AvatarSelectorDialog(
        primary: widget.primary,
        onSurface: widget.onSurface,
        surfaceContainer: widget.surfaceContainer,
      ),
    ).then((newSeed) {
      if (newSeed != null && mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelAccent = profileHeaderLevelAccent(widget.level, widget.primary);
    final levelEmoji = profileHeaderLevelEmoji(widget.level);
    final displayedLevel = profileHeaderDisplayLevel(widget.level);
    final recentIndexView = buildProfileHeaderRecentIndexView(
      recentIndex: widget.recentIndex,
      recentIndexReady: widget.recentIndexReady,
    );
    final nextLevelMessage = buildProfileHeaderNextLevelMessage(
      nextLevel: widget.nextLevel,
      pointsToNextLevel: widget.pointsToNextLevel,
    );
    final scoreLabel = widget.exactScore > 0
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
          activeDaysLast30: widget.activeDaysLast30,
          consistencyWindowDays: widget.consistencyWindowDays,
          completedSessions: widget.completedSessions,
          nextLevelMessage: nextLevelMessage,
          recentIndexView: recentIndexView,
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primaryDim: widget.primaryDim,
          onAvatarTap: _openAvatarSelector,
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            ProfileStatsBox(
              value: widget.questionsCount,
              label: 'QUEST\u00d5ES',
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
              label: 'PRECIS\u00c3O',
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
}
