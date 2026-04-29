import 'package:flutter/material.dart';
import '../../services/entitlements/entitlements_api.dart';
import '../../services/recommendations/home_recommendations_api.dart';
import '../../services/profile/profile_api.dart';
import '../../services/study_plan/study_plan_api.dart';
import 'widgets/daily_rhythm/home_daily_rhythm_card.dart';
import 'widgets/premium/home_premium_flag.dart';
import 'widgets/recommendations/home_recommendations_section.dart';
import 'widgets/recent_performance/home_recent_performance_card.dart';
import 'widgets/streak/home_master_streak_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.profileFuture,
    required this.entitlementsFuture,
    required this.recommendationsFuture,
    required this.studyPlanFuture,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
    required this.accent,
    required this.success,
    required this.danger,
    required this.userName,
    required this.onRefresh,
    required this.onOpenPremium,
    required this.onManageSubscription,
  });

  final Future<ProfileScoreData> profileFuture;
  final Future<EntitlementStatus> entitlementsFuture;
  final Future<HomeRecommendationsData> recommendationsFuture;
  final Future<StudyPlanData> studyPlanFuture;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;
  final Color accent;
  final Color success;
  final Color danger;
  final String userName;
  final RefreshCallback onRefresh;
  final VoidCallback onOpenPremium;
  final VoidCallback onManageSubscription;

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
          const SizedBox(height: 4),
          HomePremiumFlag(
            entitlementsFuture: entitlementsFuture,
            surfaceContainer: surfaceContainer,
            surfaceContainerHigh: surfaceContainerHigh,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
            primaryDim: primaryDim,
            accent: accent,
            onOpenPremium: onOpenPremium,
            onManageSubscription: onManageSubscription,
          ),
          const SizedBox(height: 18),
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
            success: success,
          ),
          const SizedBox(height: 18),
          HomeRecommendationsSection(
            recommendationsFuture: recommendationsFuture,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
            success: success,
            danger: danger,
            surfaceContainerHigh: surfaceContainerHigh,
          ),
          const SizedBox(height: 22),
          HomeRecentPerformanceCard(
            profileFuture: profileFuture,
            surfaceContainer: surfaceContainer,
            surfaceContainerHigh: surfaceContainerHigh,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
            success: success,
            danger: danger,
          ),
        ],
      ),
    );
  }
}
