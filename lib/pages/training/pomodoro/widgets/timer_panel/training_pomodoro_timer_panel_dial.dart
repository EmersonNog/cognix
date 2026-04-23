part of '../training_pomodoro_timer_panel.dart';

class _TrainingPomodoroCountdownDial extends StatelessWidget {
  const _TrainingPomodoroCountdownDial({
    required this.isFocusPhase,
    required this.isEditingDuration,
    required this.timeDisplay,
    required this.progress,
    required this.primary,
    required this.ringTrackColor,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.minutesController,
    required this.secondsController,
    required this.minutesFocusNode,
    required this.secondsFocusNode,
    required this.onEditCenter,
    required this.onSubmitInlineEdit,
  });

  final bool isFocusPhase;
  final bool isEditingDuration;
  final String timeDisplay;
  final double progress;
  final Color primary;
  final Color ringTrackColor;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final TextEditingController minutesController;
  final TextEditingController secondsController;
  final FocusNode minutesFocusNode;
  final FocusNode secondsFocusNode;
  final VoidCallback onEditCenter;
  final bool Function() onSubmitInlineEdit;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _TrainingPomodoroRingPainter(
                progress: progress,
                trackColor: ringTrackColor,
                progressColor: primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: isEditingDuration ? null : onEditCenter,
            child: Container(
              margin: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: surfaceContainer,
                shape: BoxShape.circle,
                border: Border.all(color: surfaceContainerHigh),
              ),
              child: Center(
                child: _TrainingPomodoroDialContent(
                  isFocusPhase: isFocusPhase,
                  isEditingDuration: isEditingDuration,
                  timeDisplay: timeDisplay,
                  primary: primary,
                  surfaceContainer: surfaceContainer,
                  surfaceContainerHigh: surfaceContainerHigh,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  minutesController: minutesController,
                  secondsController: secondsController,
                  minutesFocusNode: minutesFocusNode,
                  secondsFocusNode: secondsFocusNode,
                  onSubmitInlineEdit: onSubmitInlineEdit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
