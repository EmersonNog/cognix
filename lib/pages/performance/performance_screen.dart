import 'package:flutter/material.dart';

import '../../services/core/api_client.dart' show isSubscriptionRequiredError;
import '../../services/profile/profile_api.dart';
import '../../theme/cognix_theme_colors.dart';
import '../../utils/api_datetime.dart';
import 'utils/performance_utils.dart';
import 'widgets/performance_sections.dart';
import 'widgets/performance_widgets.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({
    super.key,
    required this.profile,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    this.onRefresh,
  }) : profileFuture = null,
       _embedded = false;

  const PerformanceScreen.embedded({
    super.key,
    required this.profileFuture,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    this.onRefresh,
  }) : profile = null,
       _embedded = true;

  final ProfileScoreData? profile;
  final Future<ProfileScoreData>? profileFuture;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final RefreshCallback? onRefresh;
  final bool _embedded;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    if (profile != null) {
      return _PerformanceScreenFrame(
        profile: profile!,
        onSurface: onSurface,
        onSurfaceMuted: onSurfaceMuted,
        primary: primary,
        surface: colors.surface,
        surfaceContainerHigh: colors.surfaceContainerHigh,
        embedded: _embedded,
        onRefresh: onRefresh,
      );
    }

    return FutureBuilder<ProfileScoreData>(
      future: profileFuture ?? fetchProfileScore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return _embedded
              ? Center(child: CircularProgressIndicator(color: primary))
              : Scaffold(
                  backgroundColor: colors.surface,
                  body: Center(
                    child: CircularProgressIndicator(color: primary),
                  ),
                );
        }

        if (!snapshot.hasData &&
            snapshot.hasError &&
            isSubscriptionRequiredError(snapshot.error)) {
          return _PerformanceScreenFrame(
            profile: const ProfileScoreData.empty(),
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
            surface: colors.surface,
            surfaceContainerHigh: colors.surfaceContainerHigh,
            embedded: _embedded,
            onRefresh: onRefresh,
            previewMode: true,
          );
        }

        if (!snapshot.hasData) {
          return _PerformanceErrorState(
            embedded: _embedded,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
            onRefresh: onRefresh,
          );
        }

        return _PerformanceScreenFrame(
          profile: snapshot.data!,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
          surface: colors.surface,
          surfaceContainerHigh: colors.surfaceContainerHigh,
          embedded: _embedded,
          onRefresh: onRefresh,
        );
      },
    );
  }
}

class _PerformanceScreenFrame extends StatelessWidget {
  const _PerformanceScreenFrame({
    required this.profile,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.surface,
    required this.surfaceContainerHigh,
    required this.embedded,
    required this.onRefresh,
    this.previewMode = false,
  });

  final ProfileScoreData profile;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color surface;
  final Color surfaceContainerHigh;
  final bool embedded;
  final RefreshCallback? onRefresh;
  final bool previewMode;

  @override
  Widget build(BuildContext context) {
    final content = _PerformanceScreenContent(
      profile: profile,
      onSurface: onSurface,
      onSurfaceMuted: onSurfaceMuted,
      primary: primary,
      surfaceContainerHigh: surfaceContainerHigh,
      embedded: embedded,
      onRefresh: onRefresh,
      previewMode: previewMode,
    );

    if (embedded) {
      return content;
    }

    final pageBackgroundColor = surface;

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: pageBackgroundColor,
        surfaceTintColor: pageBackgroundColor,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Painel de desempenho'),
      ),
      body: content,
    );
  }
}

class _PerformanceScreenContent extends StatelessWidget {
  const _PerformanceScreenContent({
    required this.profile,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.surfaceContainerHigh,
    required this.embedded,
    required this.onRefresh,
    this.previewMode = false,
  });

  final ProfileScoreData profile;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color surfaceContainerHigh;
  final bool embedded;
  final RefreshCallback? onRefresh;
  final bool previewMode;

  @override
  Widget build(BuildContext context) {
    final view = PerformanceViewData.fromProfile(profile);
    final insight = profile.aiInsight;

    final listView = ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        20,
        embedded ? 0 : 8,
        20,
        embedded ? 120 : 30,
      ),
      children: [
        MomentIndicatorsSection(
          view: view,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          previewMode: previewMode,
        ),
        DisciplineSection(
          view: view,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
        ),
        EfficiencySection(
          view: view,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          previewMode: previewMode,
        ),
        PerformanceInsightCard(
          title: insight?.title ?? 'Leitura do cenário',
          description:
              insight?.summary ??
              buildPerformanceNarrative(
                leaderDiscipline: view.leader?.discipline,
                activeDisciplineCount: view.activeDisciplineCount,
                activeDaysLast30: profile.activeDaysLast30,
                consistencyWindowDays: profile.consistencyWindowDays,
                accuracyPercent: profile.accuracyPercent,
                completedSessions: profile.completedSessions,
              ),
          priority: insight?.priority,
          riskLevel: insight?.riskLevel,
          nextAction: insight?.nextAction,
          confidence: insight?.confidence,
          generatedAtLabel: insight?.generatedAt == null
              ? null
              : 'Atualizado em ${formatShortDateTime(insight!.generatedAt)}',
          primary: primary,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          surfaceContainerHigh: surfaceContainerHigh,
          previewMode: previewMode,
        ),
      ],
    );

    if (onRefresh == null) {
      return listView;
    }

    return RefreshIndicator(
      onRefresh: onRefresh!,
      color: primary,
      backgroundColor: surfaceContainerHigh,
      child: listView,
    );
  }
}

class _PerformanceErrorState extends StatelessWidget {
  const _PerformanceErrorState({
    required this.embedded,
    required this.onSurfaceMuted,
    required this.primary,
    required this.onRefresh,
  });

  final bool embedded;
  final Color onSurfaceMuted;
  final Color primary;
  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    final child = ListView(
      padding: EdgeInsets.fromLTRB(
        20,
        embedded ? 0 : 8,
        20,
        embedded ? 120 : 30,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              primary.withValues(alpha: 0.04),
              colors.surfaceContainerHigh,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colors.onSurfaceMuted.withValues(alpha: 0.12),
            ),
          ),
          child: Text(
            'Não foi possível carregar o painel de desempenho agora.',
            style: TextStyle(color: onSurfaceMuted, fontSize: 14, height: 1.4),
          ),
        ),
      ],
    );

    if (embedded && onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        color: primary,
        backgroundColor: colors.surfaceContainerHigh,
        child: child,
      );
    }

    if (embedded) {
      return child;
    }

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: child,
    );
  }
}
