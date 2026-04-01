import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth_theme.dart';
import 'decorations.dart';

class AuthIntro extends StatelessWidget {
  const AuthIntro({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.useGlassBadge = true,
    this.showWordmark = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool useGlassBadge;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showWordmark)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: AuthTheme.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Cognix',
                style: GoogleFonts.plusJakartaSans(
                  color: AuthTheme.onSurfaceMuted,
                  fontSize: 12.5,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        else
          Align(
            alignment: Alignment.center,
            child: useGlassBadge
                ? GlassBadge(
                    child: Icon(icon, color: AuthTheme.primary, size: 20),
                  )
                : Icon(icon, color: AuthTheme.primary, size: 20),
          ),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            color: AuthTheme.onSurface,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: AuthTheme.onSurfaceMuted,
            fontSize: 14.2,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
