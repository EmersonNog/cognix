import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeWritingCard extends StatelessWidget {
  const HomeWritingCard({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;

  static const _accent = Color(0xFFFFC56E);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => Navigator.of(context).pushNamed('writing'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceContainer,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: _accent.withValues(alpha: 0.18)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_accent.withValues(alpha: 0.12), surfaceContainer],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(Icons.edit_note_rounded, color: _accent),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Redação Cognix',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              color: onSurface,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _accent.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'IA',
                            style: GoogleFonts.plusJakartaSans(
                              color: _accent,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tema, estrutura guiada, checklist e reescrita assistida.',
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted,
                        fontSize: 12.8,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: _accent,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
