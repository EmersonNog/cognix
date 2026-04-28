import 'package:flutter/material.dart';

import '../../services/core/api_client.dart' show isSubscriptionRequiredError;
import '../../services/profile/profile_api.dart';
import '../../theme/cognix_theme_colors.dart';
import 'profile_details_screen.dart';
import 'widgets/profile_discipline_grid.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_open_panel_card.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.profileFuture,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
    required this.userName,
    required this.onRefresh,
  });

  final Future<ProfileScoreData> profileFuture;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;
  final String userName;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileScoreData>(
      future: profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final subscriptionRequired =
            snapshot.hasError && isSubscriptionRequiredError(snapshot.error);
        final profile = snapshot.data ?? const ProfileScoreData.empty();

        return RefreshIndicator(
          onRefresh: onRefresh,
          color: primary,
          backgroundColor: surfaceContainer,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (snapshot.hasError &&
                    !isSubscriptionRequiredError(snapshot.error)) ...[
                  _ProfileErrorBanner(onSurface: onSurface),
                  const SizedBox(height: 16),
                ],
                ProfileHeader(
                  userName: userName,
                  level: profile.level,
                  score: profile.score,
                  exactScore: profile.exactScore,
                  coinsBalance: profile.coinsBalance,
                  equippedAvatarSeed: profile.equippedAvatarSeed,
                  avatarStore: profile.avatarStore,
                  recentIndex: profile.recentIndex,
                  recentIndexReady: profile.recentIndexReady,
                  questionsCount: profile.questionsAnswered.toString(),
                  studyHoursLabel: _formatStudyHours(profile.totalStudySeconds),
                  accuracyLabel:
                      '${profile.accuracyPercent.toStringAsFixed(0)}%',
                  completedSessions: profile.completedSessions,
                  activeDaysLast30: profile.activeDaysLast30,
                  consistencyWindowDays: profile.consistencyWindowDays,
                  nextLevel: profile.nextLevel,
                  pointsToNextLevel: profile.pointsToNextLevel,
                  surfaceContainer: surfaceContainer,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  primary: primary,
                  primaryDim: primaryDim,
                  onRefreshProfile: onRefresh,
                  previewMode: subscriptionRequired,
                  onLockedTap: () =>
                      Navigator.of(context).pushNamed('subscription'),
                ),
                const SizedBox(height: 18),
                _ProfileSectionHeader(
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  previewMode: subscriptionRequired,
                ),
                const SizedBox(height: 16),
                ProfileDisciplineGrid(
                  items: profile.questionsByDiscipline,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  previewMode: subscriptionRequired,
                ),
                const SizedBox(height: 18),
                ProfileOpenPanelCard(
                  onTap: () => _openDetails(context, profile),
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  primary: primary,
                  icon: Icons.dashboard_customize_rounded,
                  title: 'Abrir painel pessoal',
                  subtitle:
                      'Acesse planos, metas de estudo e suporte em uma área mais geral da sua conta.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openDetails(BuildContext context, ProfileScoreData profile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileDetailsScreen(
          profile: profile,
          surfaceContainer: surfaceContainer,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
      ),
    );
  }

  String _formatStudyHours(int totalStudySeconds) {
    if (totalStudySeconds <= 0) {
      return '0s';
    }

    final hours = totalStudySeconds ~/ 3600;
    final minutes = (totalStudySeconds % 3600) ~/ 60;
    final seconds = totalStudySeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    }

    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }

    return '${seconds}s';
  }
}

class _ProfileErrorBanner extends StatelessWidget {
  const _ProfileErrorBanner({required this.onSurface});

  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.danger.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.danger.withValues(alpha: 0.18)),
      ),
      child: Text(
        'Não foi possível atualizar o score agora. Exibindo o último estado local disponível.',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: onSurface, height: 1.4),
      ),
    );
  }
}

class _ProfileSectionHeader extends StatelessWidget {
  const _ProfileSectionHeader({
    required this.onSurface,
    required this.onSurfaceMuted,
    this.previewMode = false,
  });

  final Color onSurface;
  final Color onSurfaceMuted;
  final bool previewMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          previewMode ? 'Painel premium' : 'Painel pessoal',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          previewMode
              ? 'Desbloqueie score por disciplina, consistência e evolução da sua rotina.'
              : 'Acompanhe sua distribuição de questões e a consistência da sua rotina.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: onSurfaceMuted, height: 1.4),
        ),
      ],
    );
  }
}
