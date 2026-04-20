import 'package:flutter/material.dart';
import '../../../../services/profile/profile_api.dart';
import 'home_streak_card_content.dart';
import 'home_streak_card_view_state.dart';

class HomeMasterStreakCard extends StatelessWidget {
  const HomeMasterStreakCard({
    super.key,
    required this.profileFuture,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.success,
  });

  final Future<ProfileScoreData> profileFuture;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color success;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileScoreData>(
      future: profileFuture,
      builder: (context, snapshot) {
        final profile = snapshot.data ?? const ProfileScoreData.empty();
        final state = HomeStreakCardViewState.fromProfile(
          profile,
          isLoading:
              snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData,
          primary: primary,
          success: success,
        );

        return HomeStreakCardContent(
          state: state,
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
        );
      },
    );
  }
}
