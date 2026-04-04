import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'profile_header_utils.dart';

class ProfileHeaderRecentIndexCardNative extends StatefulWidget {
  const ProfileHeaderRecentIndexCardNative({
    super.key,
    required this.view,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final ProfileHeaderRecentIndexViewData view;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  State<ProfileHeaderRecentIndexCardNative> createState() =>
      _ProfileHeaderRecentIndexCardNativeState();
}

class _ProfileHeaderRecentIndexCardNativeState
    extends State<ProfileHeaderRecentIndexCardNative> {
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
            child: AnimatedSize(
              duration: const Duration(milliseconds: 420),
              reverseDuration: const Duration(milliseconds: 320),
              curve: Curves.easeOutQuart,
              alignment: Alignment.topCenter,
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _isExpanded ? 1 : 0,
                child: Padding(
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
                          _NativeRecentIndexBadge(
                            accent: widget.view.accent,
                            index: widget.view.index,
                            indexLabel: widget.view.indexLabel,
                            onSurface: widget.onSurface,
                            onSurfaceMuted: widget.onSurfaceMuted,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _NativeRecentIndexBar(
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NativeRecentIndexBadge extends StatelessWidget {
  const _NativeRecentIndexBadge({
    required this.accent,
    required this.index,
    required this.indexLabel,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final Color accent;
  final int index;
  final String? indexLabel;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 11, 13, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF28304F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(0.3)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '\u00cdNDICE',
                style: GoogleFonts.plusJakartaSans(
                  color: accent.withOpacity(0.92),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            indexLabel ?? '$index/100',
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _NativeRecentIndexBar extends StatelessWidget {
  const _NativeRecentIndexBar({required this.accent, required this.index});

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
