import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeMultiplayerCard extends StatefulWidget {
  const HomeMultiplayerCard({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;

  @override
  State<HomeMultiplayerCard> createState() => _HomeMultiplayerCardState();
}

class _HomeMultiplayerCardState extends State<HomeMultiplayerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final pulseValue = _pulse.value;

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: widget.surfaceContainer,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: widget.primary.withValues(alpha: 0.2 + pulseValue * 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.primary.withValues(
                  alpha: 0.08 + pulseValue * 0.06,
                ),
                blurRadius: 18 + pulseValue * 10,
                offset: const Offset(0, 10),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.primaryDim.withValues(alpha: 0.24),
                widget.surfaceContainer,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -40 + pulseValue * 8,
                right: -36,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        widget.primary.withValues(
                          alpha: 0.22 + pulseValue * 0.08,
                        ),
                        widget.primary.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -52,
                left: -28,
                child: Transform.scale(
                  scale: 0.95 + pulseValue * 0.08,
                  child: Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.primaryDim.withValues(alpha: 0.12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: widget.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                              color: widget.primary.withValues(
                                alpha: 0.18 + pulseValue * 0.14,
                              ),
                            ),
                          ),
                          child: Icon(
                            Icons.groups_2_rounded,
                            color: widget.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Arena multiplayer',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.manrope(
                                        color: widget.onSurface,
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 4.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.primary.withValues(
                                        alpha: 0.12 + pulseValue * 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: widget.primary.withValues(
                                          alpha: 0.18 + pulseValue * 0.14,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'AO VIVO',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: widget.primary,
                                        fontSize: 10,
                                        letterSpacing: 0.8,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Crie uma sala com PIN ou entre em uma disputa em tempo real.',
                                style: GoogleFonts.inter(
                                  color: widget.onSurfaceMuted,
                                  fontSize: 13,
                                  height: 1.38,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _HomeMultiplayerAction(
                            label: 'Criar sala',
                            icon: Icons.add_rounded,
                            backgroundColor: widget.primary,
                            foregroundColor: const Color(0xFF060E20),
                            onTap: () => Navigator.of(
                              context,
                            ).pushNamed('multiplayer-create'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _HomeMultiplayerAction(
                            label: 'Entrar',
                            icon: Icons.login_rounded,
                            backgroundColor: widget.surfaceContainerHigh,
                            foregroundColor: widget.onSurface,
                            borderColor: widget.primary.withValues(alpha: 0.12),
                            onTap: () => Navigator.of(
                              context,
                            ).pushNamed('multiplayer-join'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeMultiplayerAction extends StatelessWidget {
  const _HomeMultiplayerAction({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
            border: borderColor == null
                ? null
                : Border.all(color: borderColor!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    color: foregroundColor,
                    fontSize: 13.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
