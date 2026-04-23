import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../navigation/app_route_observer.dart';
import '../../../../theme/cognix_theme_colors.dart';
import '../models/training_pomodoro_models.dart';
import '../training_pomodoro_overlay_controller.dart';
import '../training_pomodoro_screen.dart';

class TrainingPomodoroGlobalIndicator extends StatefulWidget {
  const TrainingPomodoroGlobalIndicator({super.key});

  @override
  State<TrainingPomodoroGlobalIndicator> createState() =>
      _TrainingPomodoroGlobalIndicatorState();
}

class _TrainingPomodoroGlobalIndicatorState
    extends State<TrainingPomodoroGlobalIndicator> {
  static const double _badgeWidth = 110;
  static const double _badgeHeight = 58;
  static const double _horizontalMargin = 16;
  static const double _verticalMargin = 8;
  static const double _defaultTopSpacing = 64;

  Offset? _position;
  bool _isOpeningPomodoro = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: trainingPomodoroOverlayController,
      builder: (context, _) {
        if (!trainingPomodoroOverlayController.isVisible) {
          return const SizedBox.shrink();
        }

        final mediaQuery = MediaQuery.of(context);
        final screenSize = mediaQuery.size;
        final safePadding = mediaQuery.padding;
        final theme = Theme.of(context);
        final colors = context.cognixColors;
        final isPausePhase =
            trainingPomodoroOverlayController.phase ==
            TrainingPomodoroPhase.pause;
        final cardColor = isPausePhase ? colors.secondary : colors.primary;
        final foregroundColor = isPausePhase
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.onPrimary;
        final labelColor = foregroundColor.withValues(alpha: 0.72);
        final defaultPosition = Offset(
          screenSize.width - _badgeWidth - _horizontalMargin,
          safePadding.top + _defaultTopSpacing,
        );
        final resolvedPosition = _clampPosition(
          _position ?? defaultPosition,
          screenSize: screenSize,
          safePadding: safePadding,
        );

        return Positioned(
          left: resolvedPosition.dx,
          top: resolvedPosition.dy,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _isOpeningPomodoro ? null : () => _openPomodoro(context),
            onPanStart: (_) {
              if (_position == null) {
                setState(() => _position = resolvedPosition);
              }
            },
            onPanUpdate: (details) {
              setState(() {
                _position = _clampPosition(
                  (_position ?? resolvedPosition) + details.delta,
                  screenSize: screenSize,
                  safePadding: safePadding,
                );
              });
            },
            child: Material(
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: _badgeWidth,
                height: _badgeHeight,
                padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: foregroundColor.withValues(alpha: 0.92),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isPausePhase ? 'PAUSA' : 'FOCO',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              color: labelColor,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.6,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trainingPomodoroOverlayController.timeDisplay,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              color: foregroundColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Offset _clampPosition(
    Offset position, {
    required Size screenSize,
    required EdgeInsets safePadding,
  }) {
    final minX = _verticalMargin;
    final maxX = screenSize.width - _badgeWidth - _verticalMargin;
    final minY = safePadding.top + _verticalMargin;
    final maxY =
        screenSize.height -
        safePadding.bottom -
        _badgeHeight -
        _horizontalMargin;

    return Offset(
      position.dx.clamp(minX, maxX).toDouble(),
      position.dy.clamp(minY, maxY).toDouble(),
    );
  }

  Future<void> _openPomodoro(BuildContext context) async {
    if (_isOpeningPomodoro) return;

    final colors = context.cognixColors;
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return;

    setState(() => _isOpeningPomodoro = true);
    try {
      await navigator.push(
        MaterialPageRoute(
          builder: (_) => TrainingPomodoroScreen(
            surfaceContainer: colors.surfaceContainer,
            surfaceContainerHigh: colors.surfaceContainerHigh,
            onSurface: colors.onSurface,
            onSurfaceMuted: colors.onSurfaceMuted,
            primary: colors.primary,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isOpeningPomodoro = false);
      }
    }
  }
}
