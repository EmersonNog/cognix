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
  });

  final ProfileScoreData profile;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final view = PerformanceViewData.fromProfile(profile);

    return Scaffold(
      backgroundColor: const Color(0xFF05051A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
        elevation: 0,
        title: const Text('Painel de desempenho'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
      ),
    );
  }
}
