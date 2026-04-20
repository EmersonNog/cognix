import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_security_palette.dart';

class AccountSecurityExpandableCard extends StatelessWidget {
  const AccountSecurityExpandableCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
    this.borderColor,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AccountSecurityPalette.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor ?? AccountSecurityPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onToggle,
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              overlayColor: const WidgetStatePropertyAll<Color?>(
                Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.manrope(
                              color: AccountSecurityPalette.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            style: GoogleFonts.inter(
                              color: AccountSecurityPalette.onSurfaceMuted,
                              fontSize: 12.5,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: accent,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 420),
              reverseDuration: const Duration(milliseconds: 320),
              curve: Curves.easeOutQuart,
              alignment: Alignment.topCenter,
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: isExpanded ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
