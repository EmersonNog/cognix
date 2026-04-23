import 'package:flutter/material.dart';

import '../areas/training_areas_screen.dart';
import '../flashcards/training_flashcards_screen.dart';
import '../multiplayer/training_multiplayer_screen.dart';
import '../pomodoro/training_pomodoro_screen.dart';
import 'widgets/training_tab_body.dart';

class TrainingTab extends StatelessWidget {
  const TrainingTab({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.onRefreshHubData,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final RefreshCallback onRefreshHubData;

  @override
  Widget build(BuildContext context) {
    return TrainingTabBody(
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      onSurface: onSurface,
      onSurfaceMuted: onSurfaceMuted,
      primary: primary,
      onRefresh: onRefreshHubData,
      onOpenAreas: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TrainingAreasScreen(
              surfaceContainer: surfaceContainer,
              surfaceContainerHigh: surfaceContainerHigh,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              primary: primary,
            ),
          ),
        );
      },
      onOpenMultiplayer: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TrainingMultiplayerScreen(
              surfaceContainer: surfaceContainer,
              surfaceContainerHigh: surfaceContainerHigh,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              primary: primary,
            ),
          ),
        );
      },
      onOpenWriting: () {
        Navigator.of(context).pushNamed('writing');
      },
      onOpenFlashcards: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TrainingFlashcardsScreen(
              surfaceContainer: surfaceContainer,
              surfaceContainerHigh: surfaceContainerHigh,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              primary: primary,
            ),
          ),
        );
      },
      onOpenPomodoro: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TrainingPomodoroScreen(
              surfaceContainer: surfaceContainer,
              surfaceContainerHigh: surfaceContainerHigh,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              primary: primary,
            ),
          ),
        );
      },
    );
  }
}
