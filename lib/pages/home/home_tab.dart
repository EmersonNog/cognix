import 'package:flutter/material.dart';
import '../../services/profile/profile_api.dart';
import '../../services/study_plan/study_plan_api.dart';
import 'widgets/home_daily_rhythm_card.dart';
import 'widgets/home_master_streak_card.dart';
import 'widgets/home_recommendations_section.dart';
import 'widgets/home_recent_performance_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.profileFuture,
    required this.studyPlanFuture,
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
  final Future<StudyPlanData> studyPlanFuture;
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
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: primary,
      backgroundColor: surfaceContainer,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
        children: [
          HomeDailyRhythmCard(
            studyPlanFuture: studyPlanFuture,
            surfaceContainer: surfaceContainer,
            surfaceContainerHigh: surfaceContainerHigh,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
            primaryDim: primaryDim,
            userName: userName,
          ),
          const SizedBox(height: 18),
          HomeMasterStreakCard(
            profileFuture: profileFuture,
            surfaceContainer: surfaceContainer,
            surfaceContainerHigh: surfaceContainerHigh,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
          ),
          const SizedBox(height: 22),
          HomeRecommendationsSection(
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
            surfaceContainerHigh: surfaceContainerHigh,
          ),
          const SizedBox(height: 22),
          HomeRecentPerformanceCard(
            surfaceContainer: surfaceContainer,
            surfaceContainerHigh: surfaceContainerHigh,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
          ),
        ],
      ),
    );
  }
}
