import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/profile/profile_api.dart';
part 'home_recent_performance_card_content.dart';
part 'home_recent_performance_card_utils.dart';

class HomeRecentPerformanceCard extends StatefulWidget {
  const HomeRecentPerformanceCard({
    super.key,
    required this.profileFuture,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.success,
    required this.danger,
  });

  final Future<ProfileScoreData> profileFuture;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color success;
  final Color danger;

  @override
  State<HomeRecentPerformanceCard> createState() =>
      _HomeRecentPerformanceCardState();
}

class _HomeRecentPerformanceCardState extends State<HomeRecentPerformanceCard>
    with WidgetsBindingObserver {
  Timer? _refreshTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startRefreshTicker();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshNow();
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _refreshTimer?.cancel();
    }
  }

  void _refreshNow() {
    if (!mounted) {
      return;
    }

    setState(() {
      _now = DateTime.now();
    });
  }

  void _startRefreshTicker() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _refreshNow(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Desempenho Recente',
          style: GoogleFonts.manrope(
            color: widget.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<ProfileScoreData>(
          future: widget.profileFuture,
          builder: (context, snapshot) {
            final profile = snapshot.data ?? const ProfileScoreData.empty();
            final items = profile.recentCompletedSessionsPreview
                .take(3)
                .toList();

            if (snapshot.connectionState == ConnectionState.waiting &&
                items.isEmpty) {
              return _RecentPerformanceContainer(
                surfaceContainer: widget.surfaceContainer,
                child: _RecentPerformanceLoadingState(
                  surfaceContainerHigh: widget.surfaceContainerHigh,
                ),
              );
            }

            if (items.isEmpty) {
              return _RecentPerformanceContainer(
                surfaceContainer: widget.surfaceContainer,
                child: _RecentPerformanceEmptyState(
                  onSurface: widget.onSurface,
                  onSurfaceMuted: widget.onSurfaceMuted,
                  surfaceContainerHigh: widget.surfaceContainerHigh,
                ),
              );
            }

            return _RecentPerformanceContainer(
              surfaceContainer: widget.surfaceContainer,
              child: Column(
                children: [
                  for (var index = 0; index < items.length; index++) ...[
                    _PerformanceRow(
                      item: items[index],
                      now: _now,
                      accent: _recentPerformanceAccentForAccuracy(
                        items[index].accuracyPercent,
                        attentionThreshold: profile.attentionAccuracyThreshold,
                        primary: widget.primary,
                        success: widget.success,
                        danger: widget.danger,
                      ),
                      onSurface: widget.onSurface,
                      onSurfaceMuted: widget.onSurfaceMuted,
                      surfaceContainerHigh: widget.surfaceContainerHigh,
                    ),
                    if (index < items.length - 1) const SizedBox(height: 12),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
