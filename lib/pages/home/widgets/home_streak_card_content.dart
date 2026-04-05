import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_streak_card_view_state.dart';

class HomeStreakCardContent extends StatelessWidget {
  const HomeStreakCardContent({
    super.key,
    required this.state,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final HomeStreakCardViewState state;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: state.frameColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StreakIconBadge(state: state),
              const SizedBox(width: 12),
              Expanded(
                child: _StreakHeaderText(
                  headline: state.headline,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                ),
              ),
              _StreakStatusPill(state: state),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            state.description,
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 11.9,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                state.streakValue,
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.streakLabel,
                  style: GoogleFonts.inter(
                    color: onSurfaceMuted,
                    fontSize: 11.7,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _StreakBars(
            highlightedBars: state.highlightedBars,
            accent: state.accent,
            surfaceContainerHigh: surfaceContainerHigh,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: state.footerBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: state.footerBorderColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  size: 16,
                  color: state.accent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.footerLabel,
                    style: GoogleFonts.inter(
                      color: onSurface,
                      fontSize: 11.5,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakIconBadge extends StatelessWidget {
  const _StreakIconBadge({required this.state});

  final HomeStreakCardViewState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: state.accent.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        state.icon,
        color: state.accent,
        size: 21,
      ),
    );
  }
}

class _StreakHeaderText extends StatelessWidget {
  const _StreakHeaderText({
    required this.headline,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String headline;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SEQUÊNCIA',
          style: GoogleFonts.plusJakartaSans(
            color: onSurfaceMuted,
            fontSize: 11,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          headline,
          style: GoogleFonts.manrope(
            color: onSurface,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}

class _StreakStatusPill extends StatelessWidget {
  const _StreakStatusPill({required this.state});

  final HomeStreakCardViewState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: state.badgeBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: state.badgeBorderColor),
      ),
      child: Text(
        state.badgeLabel,
        style: GoogleFonts.plusJakartaSans(
          color: state.accent,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StreakBars extends StatelessWidget {
  const _StreakBars({
    required this.highlightedBars,
    required this.accent,
    required this.surfaceContainerHigh,
  });

  final int highlightedBars;
  final Color accent;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(7, (index) {
        final isActive = index < highlightedBars;
        return Expanded(
          child: Container(
            height: 10,
            margin: EdgeInsets.only(right: index == 6 ? 0 : 6),
            decoration: BoxDecoration(
              color: isActive ? accent : surfaceContainerHigh,
              borderRadius: BorderRadius.circular(999),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.32),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : const [],
            ),
          ),
        );
      }),
    );
  }
}
