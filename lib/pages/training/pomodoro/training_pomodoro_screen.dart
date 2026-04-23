import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/cognix/cognix_messages.dart';
import 'data/training_pomodoro_ambient_audio.dart';
import 'data/training_pomodoro_feedback.dart';
import 'data/training_pomodoro_runtime.dart';
import 'data/training_pomodoro_storage.dart';
import 'models/training_pomodoro_models.dart';
import 'training_pomodoro_overlay_controller.dart';
import 'widgets/ambient_panel/training_pomodoro_ambient_track.dart';
import 'widgets/training_pomodoro_ambient_panel.dart';
import 'widgets/training_pomodoro_timer_panel.dart';

part 'state/training_pomodoro_screen_interactions.dart';
part 'state/training_pomodoro_screen_ambient.dart';
part 'state/training_pomodoro_screen_lifecycle.dart';
part 'state/training_pomodoro_screen_persistence.dart';
part 'state/training_pomodoro_screen_timer.dart';
part 'state/training_pomodoro_screen_view.dart';

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
  TrainingPomodoroAmbientTrack _selectedAmbientTrack =
      TrainingPomodoroAmbientTrack.lofi;
  bool _isAmbientPlaying = false;
  double _ambientVolume = 0.50;

  Timer? _ticker;

  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();
  final FocusNode _minutesFocusNode = FocusNode();
  final FocusNode _secondsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initScreenForState(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _handleLifecycleChangeForState(this, state);
  }

  @override
  void dispose() {
    _disposeScreenForState(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildScreenForState(this, context);

  int _secondsForPhase(TrainingPomodoroPhase phase) {
    return _settings.secondsFor(phase);
  }

  void _toggleRunning() => _toggleRunningForState(this);

  void _resetCurrentPhase() => _resetCurrentPhaseForState(this);

  void _beginInlineDurationEdit() => _beginInlineDurationEditForState(this);

  bool _commitInlineDurationEdit() => _commitInlineDurationEditForState(this);

  void _selectFocusPhase() => _selectFocusPhaseForState(this);

  void _selectPausePhase() => _selectPausePhaseForState(this);

  void _selectAmbientTrack(TrainingPomodoroAmbientTrack track) =>
      _selectAmbientTrackForState(this, track);

  void _toggleAmbientPlayback() => _toggleAmbientPlaybackForState(this);

  void _setAmbientVolume(double value) =>
      _setAmbientVolumeForState(this, value);

  void _update(VoidCallback action) => setState(action);
}
