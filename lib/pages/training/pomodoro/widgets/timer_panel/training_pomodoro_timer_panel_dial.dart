part of '../training_pomodoro_timer_panel.dart';

class _TrainingPomodoroCountdownDial extends StatelessWidget {
  const _TrainingPomodoroCountdownDial({
    required this.isFocusPhase,
    required this.isEditingDuration,
    required this.timeDisplay,
    required this.progress,
    required this.primary,
    required this.ringTrackColor,
    required this.ringGlowColor,
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
  final Color ringGlowColor;
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
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ringGlowColor,
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
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
                shape: BoxShape.circle,
                border: Border.all(color: surfaceContainerHigh),
              ),
              child: Center(
                child: _TrainingPomodoroDialContent(
                  isFocusPhase: isFocusPhase,
                  isEditingDuration: isEditingDuration,
                  timeDisplay: timeDisplay,
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

class _TrainingPomodoroDialContent extends StatelessWidget {
  const _TrainingPomodoroDialContent({
    required this.isFocusPhase,
    required this.isEditingDuration,
    required this.timeDisplay,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.minutesController,
    required this.secondsController,
    required this.minutesFocusNode,
    required this.secondsFocusNode,
    required this.onSubmitInlineEdit,
  });

  final bool isFocusPhase;
  final bool isEditingDuration;
  final String timeDisplay;
  final Color onSurface;
  final Color onSurfaceMuted;
  final TextEditingController minutesController;
  final TextEditingController secondsController;
  final FocusNode minutesFocusNode;
  final FocusNode secondsFocusNode;
  final bool Function() onSubmitInlineEdit;

  @override
  Widget build(BuildContext context) {
    final centerLabel = isFocusPhase ? 'MINUTOS' : 'PAUSA';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: isEditingDuration
          ? SizedBox(
              key: const ValueKey('editing'),
              width: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TrainingPomodoroDialLabel(
                    label: centerLabel,
                    onSurfaceMuted: onSurfaceMuted,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TrainingPomodoroTimeField(
                        controller: minutesController,
                        focusNode: minutesFocusNode,
                        onSurface: onSurface,
                        onSurfaceMuted: onSurfaceMuted,
                        label: 'MM',
                        onSubmitted: () {
                          secondsFocusNode.requestFocus();
                        },
                        onTapOutside: onSubmitInlineEdit,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          ':',
                          style: GoogleFonts.manrope(
                            color: onSurface,
                            fontSize: 58,
                            fontWeight: FontWeight.w800,
                            height: 0.92,
                          ),
                        ),
                      ),
                      _TrainingPomodoroTimeField(
                        controller: secondsController,
                        focusNode: secondsFocusNode,
                        onSurface: onSurface,
                        onSurfaceMuted: onSurfaceMuted,
                        label: 'SS',
                        onSubmitted: onSubmitInlineEdit,
                        onTapOutside: onSubmitInlineEdit,
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Column(
              key: const ValueKey('display'),
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _TrainingPomodoroDialLabel(
                  label: centerLabel,
                  onSurfaceMuted: onSurfaceMuted,
                ),
                const SizedBox(height: 18),
                Text(
                  timeDisplay,
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontSize: 72,
                    fontWeight: FontWeight.w800,
                    height: 0.92,
                  ),
                ),
              ],
            ),
    );
  }
}

class _TrainingPomodoroDialLabel extends StatelessWidget {
  const _TrainingPomodoroDialLabel({
    required this.label,
    required this.onSurfaceMuted,
  });

  final String label;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        color: onSurfaceMuted,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 3.2,
      ),
    );
  }
}

class _TrainingPomodoroTimeField extends StatelessWidget {
  const _TrainingPomodoroTimeField({
    required this.controller,
    required this.focusNode,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.label,
    required this.onSubmitted,
    required this.onTapOutside,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Color onSurface;
  final Color onSurfaceMuted;
  final String label;
  final VoidCallback onSubmitted;
  final bool Function() onTapOutside;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            onSubmitted: (_) => onSubmitted(),
            onTapOutside: (_) => onTapOutside(),
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 58,
              fontWeight: FontWeight.w800,
              height: 0.92,
            ),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceMuted,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainingPomodoroRingPainter extends CustomPainter {
  const _TrainingPomodoroRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.06;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 2, false, trackPaint);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TrainingPomodoroRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
