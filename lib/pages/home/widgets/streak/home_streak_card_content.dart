import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/profile/profile_api.dart';
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
          const SizedBox(height: 14),
          _StreakWeeklyCalendar(
            days: state.recentActivityWindow,
            accent: state.accent,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            surfaceContainerHigh: surfaceContainerHigh,
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
      child: Icon(state.icon, color: state.accent, size: 21),
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

class _StreakWeeklyCalendar extends StatelessWidget {
  const _StreakWeeklyCalendar({
    required this.days,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
  });

  final List<ProfileRecentActivityDay> days;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(days.length, (index) {
        final day = days[index];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == days.length - 1 ? 0 : 6),
            child: _StreakCalendarDayCell(
              day: day,
              accent: accent,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              surfaceContainerHigh: surfaceContainerHigh,
            ),
          ),
        );
      }),
    );
  }
}

class _StreakCalendarDayCell extends StatelessWidget {
  const _StreakCalendarDayCell({
    required this.day,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
  });

  final ProfileRecentActivityDay day;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color surfaceContainerHigh;

  @override
  Widget build(BuildContext context) {
    final isTodayActive = day.isToday && day.active;
    final isPastActive = day.active && !day.isToday;
    final backgroundColor = isTodayActive
        ? accent.withValues(alpha: 0.14)
        : surfaceContainerHigh.withValues(alpha: 0.7);
    final borderColor = day.isToday
        ? accent.withValues(alpha: 0.42)
        : Colors.white.withValues(alpha: 0.05);
    final numberBackground = isTodayActive
        ? accent
        : Colors.white.withValues(alpha: isPastActive ? 0.07 : 0.03);
    final numberColor = isTodayActive ? const Color(0xFF081120) : onSurface;
    final labelColor = day.isToday || isPastActive ? onSurface : onSurfaceMuted;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _weekdayLabel(day.date.weekday),
            style: GoogleFonts.plusJakartaSans(
              color: labelColor,
              fontSize: 9.6,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: numberBackground,
              shape: BoxShape.circle,
              boxShadow: isTodayActive
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.24),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : const [],
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.date.day}',
              style: GoogleFonts.manrope(
                color: numberColor,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 7),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isPastActive || isTodayActive
                  ? accent
                  : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isTodayActive
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : const [],
            ),
          ),
        ],
      ),
    );
  }

  static String _weekdayLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'SEG';
      case DateTime.tuesday:
        return 'TER';
      case DateTime.wednesday:
        return 'QUA';
      case DateTime.thursday:
        return 'QUI';
      case DateTime.friday:
        return 'SEX';
      case DateTime.saturday:
        return 'SAB';
      case DateTime.sunday:
        return 'DOM';
      default:
        return '--';
    }
  }
}
