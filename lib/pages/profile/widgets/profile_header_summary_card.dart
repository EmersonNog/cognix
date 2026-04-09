import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_avatar_display.dart';
import 'profile_header_metric_pill.dart';
import 'profile_header_recent_index_card.dart';
import 'profile_header_score_progress_hint.dart';
import 'profile_header_utils.dart';

class ProfileHeaderSummaryCard extends StatelessWidget {
  const ProfileHeaderSummaryCard({
    super.key,
    required this.userName,
    required this.displayedLevel,
    required this.levelAccent,
    required this.levelEmoji,
    required this.scoreLabel,
    required this.coinsLabel,
    required this.avatarSeed,
    required this.activeDaysLast30,
    required this.consistencyWindowDays,
    required this.completedSessions,
    required this.nextLevelMessage,
    required this.recentIndexView,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primaryDim,
    required this.onAvatarTap,
  });

  final String userName;
  final String displayedLevel;
  final Color levelAccent;
  final String levelEmoji;
  final String scoreLabel;
  final String coinsLabel;
  final String avatarSeed;
  final int activeDaysLast30;
  final int consistencyWindowDays;
  final int completedSessions;
  final String nextLevelMessage;
  final ProfileHeaderRecentIndexViewData recentIndexView;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primaryDim;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: <Color>[
            const Color(0xFF2A275A),
            Color.lerp(primaryDim, levelAccent, 0.35)!.withValues(alpha: 0.28),
            const Color(0xFF121B35),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ProfileAvatarDisplay(
                userName: userName,
                primary: levelAccent,
                avatarSeed: avatarSeed,
                size: 92,
                onTap: onAvatarTap,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: levelAccent.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: levelAccent.withValues(alpha: 0.24),
                                ),
                              ),
                              child: Text(
                                '$levelEmoji ${displayedLevel.toUpperCase()}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  color: levelAccent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFFC857,
                            ).withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(
                                0xFFFFC857,
                              ).withValues(alpha: 0.28),
                            ),
                          ),
                          child: Text(
                            coinsLabel.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFFFFD977),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName,
                      style: GoogleFonts.manrope(
                        color: onSurface,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nível definido por questões, precisão, simulados concluídos e consistência diária.',
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              Expanded(
                child: ProfileHeaderMetricPill(
                  label: 'Score',
                  value: '$scoreLabel/100',
                  accent: levelAccent,
                  onSurface: onSurface,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ProfileHeaderMetricPill(
                  label: 'Frequência',
                  value: '$activeDaysLast30/$consistencyWindowDays dias',
                  accent: levelAccent,
                  onSurface: onSurface,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ProfileHeaderMetricPill(
                  label: 'Simulados',
                  value: completedSessions.toString(),
                  accent: levelAccent,
                  onSurface: onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ProfileHeaderScoreProgressHint(
            message: nextLevelMessage,
            accent: levelAccent,
            onSurface: onSurface,
          ),
          const SizedBox(height: 12),
          ProfileHeaderRecentIndexCardNative(
            view: recentIndexView,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
          ),
        ],
      ),
    );
  }
}
