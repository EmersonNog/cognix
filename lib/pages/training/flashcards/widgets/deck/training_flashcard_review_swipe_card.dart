import 'package:flutter/material.dart';

class TrainingFlashcardReviewSwipeCard extends StatefulWidget {
  const TrainingFlashcardReviewSwipeCard({
    super.key,
    required this.child,
    required this.onSwiped,
    required this.leftBackground,
    required this.rightBackground,
    this.previewDirection,
  });

  final Widget child;
  final ValueChanged<DismissDirection> onSwiped;
  final Widget leftBackground;
  final Widget rightBackground;
  final DismissDirection? previewDirection;

  @override
  State<TrainingFlashcardReviewSwipeCard> createState() =>
      _TrainingFlashcardReviewSwipeCardState();
}

class _TrainingFlashcardReviewSwipeCardState
    extends State<TrainingFlashcardReviewSwipeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<Offset>? _offsetAnimation;
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 240),
        )..addListener(() {
          final animation = _offsetAnimation;
          if (animation == null) return;
          setState(() {
            _dragOffset = animation.value;
          });
        });
  }

  @override
  void didUpdateWidget(covariant TrainingFlashcardReviewSwipeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.previewDirection == widget.previewDirection) return;
    if (widget.previewDirection == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _controller.isAnimating) return;
      _dragOffset = switch (widget.previewDirection) {
        DismissDirection.startToEnd => const Offset(96, 0),
        DismissDirection.endToStart => const Offset(-96, 0),
        _ => Offset.zero,
      };
      _animateBack();
    });
  }

  void _animateBack() {
    _offsetAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller
      ..reset()
      ..forward();
  }

  void _animateAway(DismissDirection direction, double width) {
    final targetX = direction == DismissDirection.startToEnd
        ? width * 1.35
        : -width * 1.35;
    _offsetAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(targetX, _dragOffset.dy * 1.1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller
      ..reset()
      ..forward().whenComplete(() {
        if (!mounted) return;
        widget.onSwiped(direction);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final previewOffset = switch (widget.previewDirection) {
          DismissDirection.startToEnd => Offset(width * 0.30, 0),
          DismissDirection.endToStart => Offset(-width * 0.30, 0),
          _ => Offset.zero,
        };
        final visualOffset =
            _dragOffset == Offset.zero && !_controller.isAnimating
            ? previewOffset
            : _dragOffset;
        final progress = (visualOffset.dx.abs() / (width * 0.45)).clamp(
          0.0,
          1.0,
        );
        final rotation = (visualOffset.dx / width) * 0.18;
        final shouldAccept = _dragOffset.dx.abs() > width * 0.28;

        return GestureDetector(
          onPanUpdate: (details) {
            if (_controller.isAnimating) return;
            setState(() {
              _dragOffset += details.delta;
            });
          },
          onPanEnd: (_) {
            if (_controller.isAnimating) return;
            if (shouldAccept) {
              final direction = _dragOffset.dx > 0
                  ? DismissDirection.startToEnd
                  : DismissDirection.endToStart;
              _animateAway(direction, width);
            } else {
              _animateBack();
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: visualOffset.dx > 0 ? progress : 0,
                  child: widget.leftBackground,
                ),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: visualOffset.dx < 0 ? progress : 0,
                  child: widget.rightBackground,
                ),
              ),
              Transform.translate(
                offset: visualOffset,
                child: Transform.rotate(angle: rotation, child: widget.child),
              ),
            ],
          ),
        );
      },
    );
  }
}
