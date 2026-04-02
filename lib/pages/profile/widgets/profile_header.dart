import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'avatar_selector_dialog.dart';
import 'profile_avatar_display.dart';
import 'profile_stats_box.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
    required this.userName,
    required this.level,
    required this.questionsCount,
    required this.studyHours,
    required this.improvementPercentage,
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
  });

  final String userName;
  final String level;
  final String questionsCount;
  final String studyHours;
  final String improvementPercentage;
  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  void _openAvatarSelector() {
    showDialog(
      context: context,
      builder: (context) => AvatarSelectorDialog(
        primary: widget.primary,
        onSurface: widget.onSurface,
        surfaceContainer: widget.surfaceContainer,
      ),
    ).then((newSeed) {
      if (newSeed != null) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2A275A),
                widget.primaryDim.withOpacity(0.28),
                const Color(0xFF121B35),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.32),
                blurRadius: 30,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileAvatarDisplay(
                    userName: widget.userName,
                    primary: widget.primary,
                    size: 92,
                    onTap: _openAvatarSelector,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.level,
                            style: GoogleFonts.plusJakartaSans(
                              color: widget.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.userName,
                          style: GoogleFonts.manrope(
                            color: widget.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sua central de progresso, consistencia e proximos passos dentro do Cognix.',
                          style: GoogleFonts.inter(
                            color: widget.onSurfaceMuted,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2140).withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.03)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: widget.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Toque no avatar para personalizar sua identidade visual.',
                        style: GoogleFonts.inter(
                          color: widget.onSurface,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            ProfileStatsBox(
              value: widget.questionsCount,
              label: 'QUESTOES',
              icon: Icons.quiz_rounded,
              surfaceContainer: widget.surfaceContainer,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
            ),
            const SizedBox(width: 12),
            ProfileStatsBox(
              value: widget.studyHours,
              label: 'ESTUDO',
              icon: Icons.schedule_rounded,
              surfaceContainer: widget.surfaceContainer,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
            ),
            const SizedBox(width: 12),
            ProfileStatsBox(
              value: widget.improvementPercentage,
              label: 'PRECISAO',
              icon: Icons.track_changes_rounded,
              surfaceContainer: widget.surfaceContainer,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
            ),
          ],
        ),
      ],
    );
  }
}
