import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'profile_header_utils.dart';

class ProfileHeaderMomentumCardNative extends StatefulWidget {
  const ProfileHeaderMomentumCardNative({
    super.key,
    required this.view,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final ProfileHeaderMomentumViewData view;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  State<ProfileHeaderMomentumCardNative> createState() =>
      _ProfileHeaderMomentumCardNativeState();
}

class _ProfileHeaderMomentumCardNativeState
    extends State<ProfileHeaderMomentumCardNative> {
  bool _isExpanded = false;

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2140).withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _toggle,
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
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'RITMO RECENTE',
                            style: GoogleFonts.plusJakartaSans(
                              color: widget.onSurfaceMuted,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isExpanded
                                ? 'Toque para recolher o resumo'
                                : 'Toque para ver os detalhes',
                            style: GoogleFonts.inter(
                              color: widget.onSurfaceMuted,
                              fontSize: 11.5,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: widget.onSurfaceMuted,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1500),
              reverseDuration: const Duration(milliseconds: 800),
              switchInCurve: Curves.easeOutQuart,
              switchOutCurve: Curves.easeInOutCubic,
              transitionBuilder: (child, animation) {
                final fade = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                );
                final size = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                );

                return FadeTransition(
                  opacity: fade,
                  child: SizeTransition(
                    sizeFactor: size,
                    axisAlignment: -1,
                    child: child,
                  ),
                );
              },
              child: _isExpanded
                  ? Padding(
                      key: const ValueKey('expanded_momentum_content'),
                      padding: const EdgeInsets.only(top: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.view.label,
                                  style: GoogleFonts.manrope(
                                    color: widget.view.accent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              _NativeMomentumIndexBadge(
                                accent: widget.view.accent,
                                index: widget.view.index,
                                onSurface: widget.onSurface,
                                onSurfaceMuted: widget.onSurfaceMuted,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _NativeMomentumBar(
                            accent: widget.view.accent,
                            index: widget.view.index,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.view.description,
                            style: GoogleFonts.inter(
                              color: widget.onSurfaceMuted,
                              fontSize: 11.5,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(key: ValueKey('collapsed_momentum_content')),
            ),
          ),
        ],
      ),
    );
  }
}

class _NativeMomentumIndexBadge extends StatelessWidget {
  const _NativeMomentumIndexBadge({
    required this.accent,
    required this.index,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final Color accent;
  final int index;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '$index/100',
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Índice',
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _NativeMomentumBar extends StatelessWidget {
  const _NativeMomentumBar({required this.accent, required this.index});

  final Color accent;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Stack(
        children: <Widget>[
          Container(height: 8, color: Colors.white.withOpacity(0.06)),
          FractionallySizedBox(
            widthFactor: index / 100,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    accent,
                    Color.lerp(accent, Colors.white, 0.22)!,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
