import 'package:flutter/material.dart';

import '../../services/profile/profile_api.dart';
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
  }) : _embedded = false;

  const PerformanceScreen.embedded({
    super.key,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  })  : profile = null,
        _embedded = true;

  final ProfileScoreData? profile;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final bool _embedded;

  @override
  Widget build(BuildContext context) {
    if (profile != null) {
      return _PerformanceScreenFrame(
        profile: profile!,
        onSurface: onSurface,
        onSurfaceMuted: onSurfaceMuted,
        primary: primary,
        embedded: _embedded,
      );
    }

    return FutureBuilder<ProfileScoreData>(
      future: fetchProfileScore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _embedded
              ? Center(
                  child: CircularProgressIndicator(color: primary),
                )
              : Scaffold(
                  backgroundColor: const Color(0xFF05051A),
                  body: Center(
                    child: CircularProgressIndicator(color: primary),
                  ),
                );
        }

        if (!snapshot.hasData) {
          return _PerformanceErrorState(
            embedded: _embedded,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
          );
        }

        return _PerformanceScreenFrame(
          profile: snapshot.data!,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
          embedded: _embedded,
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
    required this.embedded,
  });

  final ProfileScoreData profile;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final content = _PerformanceScreenContent(
      profile: profile,
      onSurface: onSurface,
      onSurfaceMuted: onSurfaceMuted,
      primary: primary,
      embedded: embedded,
    );

    if (embedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF05051A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
        elevation: 0,
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
    required this.embedded,
  });

  final ProfileScoreData profile;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final view = PerformanceViewData.fromProfile(profile);

    return ListView(
      padding: EdgeInsets.fromLTRB(20, embedded ? 0 : 8, 20, embedded ? 120 : 30),
      children: [
        MomentIndicatorsSection(
          view: view,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
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
        ),
        PerformanceInsightCard(
          title: 'Leitura do cen\u00E1rio',
          description: buildPerformanceNarrative(
            leaderDiscipline: view.leader?.discipline,
            activeDisciplineCount: view.activeDisciplineCount,
            activeDaysLast30: profile.activeDaysLast30,
            consistencyWindowDays: profile.consistencyWindowDays,
            accuracyPercent: profile.accuracyPercent,
            completedSessions: profile.completedSessions,
          ),
          primary: primary,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
        ),
      ],
    );
  }
}

class _PerformanceErrorState extends StatelessWidget {
  const _PerformanceErrorState({
    required this.embedded,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final bool embedded;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final child = ListView(
      padding: EdgeInsets.fromLTRB(20, embedded ? 0 : 8, 20, embedded ? 120 : 30),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              primary.withOpacity(0.04),
              const Color(0xFF141F38),
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Text(
            'N\u00E3o foi poss\u00EDvel carregar o painel de desempenho agora.',
            style: TextStyle(
              color: onSurfaceMuted,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );

    if (embedded) {
      return child;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF05051A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: child,
    );
  }
}
