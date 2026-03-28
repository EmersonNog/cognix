import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_stats_box.dart';
import 'profile_avatar_display.dart';
import 'avatar_selector_dialog.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
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
        // Incrementa trigger para forçar rebuild
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar personalizado
        ProfileAvatarDisplay(
          userName: widget.userName,
          primary: widget.primary,
          onTap: _openAvatarSelector,
        ),
        const SizedBox(height: 16),
        Text(
          widget.userName,
          style: GoogleFonts.manrope(
            color: widget.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: widget.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.level,
            style: GoogleFonts.plusJakartaSans(
              color: widget.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Stats em boxes
        Row(
          children: [
            ProfileStatsBox(
              value: widget.questionsCount,
              label: 'QUESTÕES',
              surfaceContainer: widget.surfaceContainer,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
            ),
            const SizedBox(width: 12),
            ProfileStatsBox(
              value: widget.studyHours,
              label: 'ESTUDO',
              surfaceContainer: widget.surfaceContainer,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
            ),
            const SizedBox(width: 12),
            ProfileStatsBox(
              value: widget.improvementPercentage,
              label: 'PRECISÃO',
              surfaceContainer: widget.surfaceContainer,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
            ),
          ],
        ),
      ],
    );
  }
}
