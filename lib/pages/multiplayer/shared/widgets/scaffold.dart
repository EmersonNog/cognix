import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette.dart';

class MultiplayerScaffold extends StatelessWidget {
  const MultiplayerScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    required this.palette,
    required this.child,
    this.onBack,
    this.showBackButton = true,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final MultiplayerPalette palette;
  final Widget child;
  final VoidCallback? onBack;
  final bool showBackButton;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: _Glow(color: palette.primary.withValues(alpha: 0.24)),
          ),
          Positioned(
            bottom: 80,
            left: -110,
            child: _Glow(color: palette.secondary.withValues(alpha: 0.18)),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    if (showBackButton) ...[
                      _BackButton(palette: palette, onBack: onBack),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.manrope(
                              color: palette.onSurface,
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            subtitle,
                            style: GoogleFonts.inter(
                              color: palette.onSurfaceMuted,
                              fontSize: 12.5,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    trailing ??
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: palette.primary.withValues(alpha: 0.13),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            leadingIcon,
                            color: palette.primary,
                            size: 22,
                          ),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(child: child),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.palette, this.onBack});

  final MultiplayerPalette palette;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onBack ?? () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: palette.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(Icons.arrow_back_rounded, color: palette.onSurface),
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
