import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.footerText,
    this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final String footerText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surfaceContainer,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.manrope(
                            color: onSurface,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: GoogleFonts.inter(
                            color: onSurfaceMuted,
                            fontSize: 11.5,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _FooterRow(
                text: footerText,
                primary: primary,
                onSurfaceMuted: onSurfaceMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterRow extends StatelessWidget {
  const _FooterRow({
    required this.text,
    required this.primary,
    required this.onSurfaceMuted,
  });

  final String text;
  final Color primary;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AvatarDot(color: primary.withOpacity(0.85)),
        const SizedBox(width: 6),
        _AvatarDot(color: primary.withOpacity(0.6)),
        const SizedBox(width: 6),
        _AvatarDot(color: primary.withOpacity(0.4)),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 10.5),
        ),
      ],
    );
  }
}

class _AvatarDot extends StatelessWidget {
  const _AvatarDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
    );
  }
}
