import 'package:flutter/material.dart';

import '../../services/profile/profile_api.dart';
import '../performance/performance_screen.dart';
import 'widgets/home_daily_rhythm_card.dart';
import 'widgets/home_master_streak_card.dart';
import 'widgets/home_performance_cta_card.dart';
import 'widgets/home_recommendations_section.dart';
import 'widgets/home_recent_performance_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
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
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final Future<ProfileScoreData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = fetchProfileScore();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        HomeDailyRhythmCard(
          surfaceContainer: widget.surfaceContainer,
          surfaceContainerHigh: widget.surfaceContainerHigh,
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primary: widget.primary,
          primaryDim: widget.primaryDim,
          userName: widget.userName,
        ),
        const SizedBox(height: 18),
        HomeMasterStreakCard(
          surfaceContainer: widget.surfaceContainer,
          surfaceContainerHigh: widget.surfaceContainerHigh,
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primary: widget.primary,
        ),
        const SizedBox(height: 18),
        FutureBuilder<ProfileScoreData>(
          future: _profileFuture,
          builder: (context, snapshot) {
            final profile = snapshot.data;
            if (profile == null) {
              return const SizedBox.shrink();
            }

            return HomePerformanceCtaCard(
              onTap: () => _openPerformance(profile),
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
            );
          },
        ),
        const SizedBox(height: 22),
        HomeRecommendationsSection(
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primary: widget.primary,
          surfaceContainerHigh: widget.surfaceContainerHigh,
        ),
        const SizedBox(height: 22),
        HomeRecentPerformanceCard(
          surfaceContainer: widget.surfaceContainer,
          surfaceContainerHigh: widget.surfaceContainerHigh,
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primary: widget.primary,
        ),
      ],
    );
  }

  void _openPerformance(ProfileScoreData profile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PerformanceScreen(
          profile: profile,
          onSurface: widget.onSurface,
          onSurfaceMuted: widget.onSurfaceMuted,
          primary: widget.primary,
        ),
      ),
    );
  }
}
