import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/cognix/cognix_messages.dart';
import 'data/training_pomodoro_feedback.dart';
import 'data/training_pomodoro_runtime.dart';
import 'data/training_pomodoro_storage.dart';
import 'models/training_pomodoro_models.dart';
import 'training_pomodoro_overlay_controller.dart';
import 'widgets/training_pomodoro_timer_panel.dart';

part 'state/training_pomodoro_screen_interactions.dart';
part 'state/training_pomodoro_screen_persistence.dart';
part 'state/training_pomodoro_screen_timer.dart';

class TrainingPomodoroScreen extends StatefulWidget {
  const TrainingPomodoroScreen({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  State<TrainingPomodoroScreen> createState() => _TrainingPomodoroScreenState();
}

class _TrainingPomodoroScreenState extends State<TrainingPomodoroScreen>
    with WidgetsBindingObserver {
  TrainingPomodoroSettings _settings = const TrainingPomodoroSettings();
  TrainingPomodoroPhase _phase = TrainingPomodoroPhase.focus;
  int _remainingSeconds = const TrainingPomodoroSettings().focusSeconds;
  int _completedFocusSessions = 0;
  bool _isRunning = false;
  int? _phaseEndsAtEpochMs;
  bool _isHydrating = true;
  bool _isEditingDuration = false;

  Timer? _ticker;

  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();
  final FocusNode _minutesFocusNode = FocusNode();
  final FocusNode _secondsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    trainingPomodoroOverlayController.attachForegroundSession();
    unawaited(_hydrateSnapshot());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleResume();
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      unawaited(_persistSnapshot());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTickerForState(this);
    _minutesController.dispose();
    _secondsController.dispose();
    _minutesFocusNode.dispose();
    _secondsFocusNode.dispose();
    if (!_isHydrating) {
      trainingPomodoroOverlayController.updateSnapshot(
        _buildSnapshotForState(this),
      );
      unawaited(_persistSnapshot());
    }
    trainingPomodoroOverlayController.detachForegroundSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final totalSeconds = _secondsForPhase(_phase);
    final progress = totalSeconds == 0
        ? 0.0
        : (1 - (_remainingSeconds / totalSeconds)).clamp(0.0, 1.0).toDouble();
    final safeRemainingSeconds = _remainingSeconds.clamp(0, 5999).toInt();
    final timeDisplay =
        '${(safeRemainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(safeRemainingSeconds % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        scrolledUnderElevation: 0,
        title: Text(
          'Pomodoro',
          style: GoogleFonts.manrope(
            color: widget.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: _isHydrating
          ? Center(child: CircularProgressIndicator(color: widget.primary))
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
              children: [
                TrainingPomodoroTimerPanel(
                  isFocusPhase: _phase == TrainingPomodoroPhase.focus,
                  timeDisplay: timeDisplay,
                  progress: progress,
                  primary: widget.primary,
                  surfaceContainer: widget.surfaceContainer,
                  surfaceContainerHigh: widget.surfaceContainerHigh,
                  onSurface: widget.onSurface,
                  onSurfaceMuted: widget.onSurfaceMuted,
                  isRunning: _isRunning,
                  isEditingDuration: _isEditingDuration,
                  minutesController: _minutesController,
                  secondsController: _secondsController,
                  minutesFocusNode: _minutesFocusNode,
                  secondsFocusNode: _secondsFocusNode,
                  onSelectFocus: _selectFocusPhase,
                  onSelectPause: _selectPausePhase,
                  onEditCenter: _beginInlineDurationEdit,
                  onSubmitInlineEdit: _commitInlineDurationEdit,
                  onPrimaryAction: _toggleRunning,
                  onReset: _resetCurrentPhase,
                ),
              ],
            ),
    );
  }

  int _secondsForPhase(TrainingPomodoroPhase phase) {
    return _settings.secondsFor(phase);
  }

  Future<void> _hydrateSnapshot() => _hydrateSnapshotForState(this);

  Future<void> _persistSnapshot() => _persistSnapshotForState(this);

  void _handleResume() => _handleResumeForState(this);

  void _toggleRunning() => _toggleRunningForState(this);

  void _resetCurrentPhase() => _resetCurrentPhaseForState(this);

  void _beginInlineDurationEdit() => _beginInlineDurationEditForState(this);

  bool _commitInlineDurationEdit() => _commitInlineDurationEditForState(this);

  void _selectFocusPhase() => _selectFocusPhaseForState(this);

  void _selectPausePhase() => _selectPausePhaseForState(this);

  void _update(VoidCallback action) => setState(action);
}
