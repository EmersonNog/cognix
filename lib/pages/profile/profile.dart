import 'package:flutter/material.dart';

import '../../services/profile/profile_api.dart';
import 'profile_details_screen.dart';
import 'widgets/profile_discipline_grid.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_open_panel_card.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
    required this.userName,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;
  final String userName;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late final Future<ProfileScoreData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = fetchProfileScore();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileScoreData>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = snapshot.data ?? const ProfileScoreData.empty();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (snapshot.hasError) ...[
                _ProfileErrorBanner(onSurface: widget.onSurface),
                const SizedBox(height: 16),
              ],
              ProfileHeader(
                userName: widget.userName,
                level: profile.level,
                score: profile.score,
                exactScore: profile.exactScore,
                momentumScore: profile.momentumScore,
                exactMomentumScore: profile.exactMomentumScore,
                momentumLabel: profile.momentumLabel,
                questionsCount: profile.questionsAnswered.toString(),
                studyHoursLabel: _formatStudyHours(profile.totalStudySeconds),
                accuracyLabel: '${profile.accuracyPercent.toStringAsFixed(0)}%',
                completedSessions: profile.completedSessions,
                activeDaysLast30: profile.activeDaysLast30,
                consistencyWindowDays: profile.consistencyWindowDays,
                nextLevel: profile.nextLevel,
                pointsToNextLevel: profile.pointsToNextLevel,
                surfaceContainer: widget.surfaceContainer,
                onSurface: widget.onSurface,
                onSurfaceMuted: widget.onSurfaceMuted,
                primary: widget.primary,
                primaryDim: widget.primaryDim,
              ),
              const SizedBox(height: 18),
              _ProfileSectionHeader(
                onSurface: widget.onSurface,
                onSurfaceMuted: widget.onSurfaceMuted,
              ),
              const SizedBox(height: 16),
              ProfileDisciplineGrid(
                items: profile.questionsByDiscipline,
                onSurface: widget.onSurface,
                onSurfaceMuted: widget.onSurfaceMuted,
              ),
              const SizedBox(height: 18),
              ProfileOpenPanelCard(
                onTap: () => _openDetails(profile),
                onSurface: widget.onSurface,
                onSurfaceMuted: widget.onSurfaceMuted,
                primary: widget.primary,
                icon: Icons.dashboard_customize_rounded,
                title: 'Abrir painel pessoal',
                subtitle:
                    'Acesse planos, metas de estudo e suporte em uma área mais geral da sua conta.',
              ),
            ],
          ),
        );
      },
    );
  }

  void _openDetails(ProfileScoreData profile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileDetailsScreen(
          profile: profile,
          surfaceContainer: widget.surfaceContainer,
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primary: widget.primary,
        ),
      ),
    );
  }

  String _formatStudyHours(int totalStudySeconds) {
    if (totalStudySeconds <= 0) {
      return '0h';
    }

    final totalMinutes = (totalStudySeconds / 60).round();
    if (totalMinutes < 60) {
      return '${totalMinutes}m';
    }

    final hours = totalStudySeconds / 3600;
    final roundedHours = hours >= 10
        ? hours.round().toString()
        : hours.toStringAsFixed(1);
    return '${roundedHours}h';
  }
}

class _ProfileErrorBanner extends StatelessWidget {
  const _ProfileErrorBanner({required this.onSurface});

  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF3A1E2D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
  });

  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Painel pessoal',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Acompanhe sua distribuição de questões e a consistência da sua rotina.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: onSurfaceMuted, height: 1.4),
        ),
      ],
    );
  }
}
