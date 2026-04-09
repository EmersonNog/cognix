import 'package:flutter/material.dart';

import '../onboarding_layout.dart';

class OnboardingPageBody extends StatelessWidget {
  const OnboardingPageBody({
    super.key,
    required this.layout,
    required this.text,
    required this.highlights,
    required this.accent,
    required this.muted,
    required this.caption,
    required this.surface,
    required this.outline,
  });

  final OnboardingLayout layout;
  final String text;
  final List<String> highlights;
  final Color accent;
  final Color muted;
  final Color caption;
  final Color surface;
  final Color outline;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: muted,
            fontSize: layout.bodyFontSize,
            height: 1.5,
          ),
        ),
        SizedBox(height: layout.bodySpacing),
        Container(
          padding: EdgeInsets.fromLTRB(
            layout.panelHorizontalPadding,
            layout.panelTopPadding,
            layout.panelHorizontalPadding,
            layout.panelBottomPadding,
          ),
          decoration: BoxDecoration(
            color: surface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: outline.withValues(alpha: 0.6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Destaques',
                style: TextStyle(
                  color: caption,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
              SizedBox(height: layout.highlightsHeaderSpacing),
              LayoutBuilder(
                builder: (context, constraints) {
                  final gridWidth = constraints.maxWidth > 420
                      ? 420.0
                      : constraints.maxWidth;
                  final itemWidth =
                      (gridWidth - layout.highlightsSpacing) / 2;

                  return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: gridWidth,
                      child: Wrap(
                        spacing: layout.highlightsSpacing,
                        runSpacing: layout.highlightsSpacing,
                        children: highlights
                            .map(
                              (item) => SizedBox(
                                width: itemWidth,
                                child: _HighlightChip(
                                  label: item,
                                  accent: accent,
                                  compact: layout.compactHighlights,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HighlightChip extends StatelessWidget {
  const _HighlightChip({
    required this.label,
    required this.accent,
    required this.compact,
  });

  final String label;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: compact ? 38 : 40),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 11 : 12,
        vertical: compact ? 7 : 8,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
