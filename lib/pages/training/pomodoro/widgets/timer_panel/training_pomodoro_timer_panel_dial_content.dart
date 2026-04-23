part of '../training_pomodoro_timer_panel.dart';

const _trainingPomodoroTimeFieldDecoration = InputDecoration(
  isDense: true,
  filled: false,
  fillColor: Colors.transparent,
  border: InputBorder.none,
  enabledBorder: InputBorder.none,
  focusedBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  focusedErrorBorder: InputBorder.none,
  contentPadding: EdgeInsets.symmetric(vertical: 10),
);

class _TrainingPomodoroDialContent extends StatelessWidget {
  const _TrainingPomodoroDialContent({
    required this.isFocusPhase,
    required this.isEditingDuration,
    required this.timeDisplay,
    required this.primary,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
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
  final Color primary;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final TextEditingController minutesController;
  final TextEditingController secondsController;
  final FocusNode minutesFocusNode;
  final FocusNode secondsFocusNode;
  final bool Function() onSubmitInlineEdit;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: isEditingDuration
          ? _TrainingPomodoroEditingDialContent(
              label: isFocusPhase ? 'MINUTOS' : 'PAUSA',
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
            )
          : _TrainingPomodoroDisplayDialContent(
              label: isFocusPhase ? 'MINUTOS' : 'PAUSA',
              timeDisplay: timeDisplay,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
    );
  }
}

class _TrainingPomodoroEditingDialContent extends StatelessWidget {
  const _TrainingPomodoroEditingDialContent({
    required this.label,
    required this.primary,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.minutesController,
    required this.secondsController,
    required this.minutesFocusNode,
    required this.secondsFocusNode,
    required this.onSubmitInlineEdit,
  });

  final String label;
  final Color primary;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final TextEditingController minutesController;
  final TextEditingController secondsController;
  final FocusNode minutesFocusNode;
  final FocusNode secondsFocusNode;
  final bool Function() onSubmitInlineEdit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('editing'),
      width: 244,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _TrainingPomodoroDialLabel(
            label: label,
            onSurfaceMuted: onSurfaceMuted,
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TrainingPomodoroTimeField(
                controller: minutesController,
                focusNode: minutesFocusNode,
                primary: primary,
                surfaceContainer: surfaceContainer,
                surfaceContainerHigh: surfaceContainerHigh,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                label: 'MM',
                onSubmitted: () {
                  secondsFocusNode.requestFocus();
                },
                onTapOutside: onSubmitInlineEdit,
              ),
              _TrainingPomodoroDialSeparator(onSurface: onSurface),
              _TrainingPomodoroTimeField(
                controller: secondsController,
                focusNode: secondsFocusNode,
                primary: primary,
                surfaceContainer: surfaceContainer,
                surfaceContainerHigh: surfaceContainerHigh,
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
    );
  }
}

class _TrainingPomodoroDisplayDialContent extends StatelessWidget {
  const _TrainingPomodoroDisplayDialContent({
    required this.label,
    required this.timeDisplay,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String label;
  final String timeDisplay;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('display'),
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _TrainingPomodoroDialLabel(
          label: label,
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

class _TrainingPomodoroDialSeparator extends StatelessWidget {
  const _TrainingPomodoroDialSeparator({required this.onSurface});

  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 18),
      child: Text(
        ':',
        style: GoogleFonts.manrope(
          color: onSurface.withValues(alpha: 0.88),
          fontSize: 54,
          fontWeight: FontWeight.w800,
          height: 0.92,
        ),
      ),
    );
  }
}

class _TrainingPomodoroTimeField extends StatelessWidget {
  const _TrainingPomodoroTimeField({
    required this.controller,
    required this.focusNode,
    required this.primary,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.label,
    required this.onSubmitted,
    required this.onTapOutside,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Color primary;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final String label;
  final VoidCallback onSubmitted;
  final bool Function() onTapOutside;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: focusNode,
      builder: (context, _) {
        final isFocused = focusNode.hasFocus;
        final fillTint = isFocused
            ? primary.withValues(alpha: 0.14)
            : surfaceContainerHigh.withValues(alpha: 0.92);
        final fillColor = Color.alphaBlend(fillTint, surfaceContainer);
        final borderColor = isFocused
            ? primary.withValues(alpha: 0.88)
            : surfaceContainerHigh;

        return SizedBox(
          width: 88,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                height: 74,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor, width: 1.4),
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  cursorColor: primary,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onSubmitted: (_) => onSubmitted(),
                  onTapOutside: (_) => onTapOutside(),
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontSize: 50,
                    fontWeight: FontWeight.w800,
                    height: 0.92,
                  ),
                  decoration: _trainingPomodoroTimeFieldDecoration,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: onSurfaceMuted,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
