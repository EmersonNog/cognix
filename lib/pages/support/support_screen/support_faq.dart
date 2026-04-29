part of '../support_screen.dart';

class _SupportFaqCard extends StatelessWidget {
  const _SupportFaqCard({
    required this.palette,
    required this.item,
    required this.isExpanded,
    required this.onTap,
  });

  final _SupportPalette palette;
  final _SupportFaqItem item;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.question,
                          style: GoogleFonts.manrope(
                            color: palette.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: palette.onSurfaceMuted,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.answer,
                        style: GoogleFonts.inter(
                          color: palette.onSurfaceMuted,
                          fontSize: 12.5,
                          height: 1.55,
                        ),
                      ),
                    ),
                    if (item.actionLabel != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: palette.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: palette.primary.withValues(alpha: 0.18),
                          ),
                        ),
                        child: TextButton.icon(
                          onPressed: item.onActionTap,
                          icon: item.isActionLoading
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      palette.primary,
                                    ),
                                  ),
                                )
                              : Icon(
                                  item.actionIcon ?? Icons.touch_app_rounded,
                                ),
                          label: Text(
                            item.isActionLoading
                                ? (item.actionLoadingLabel ?? item.actionLabel!)
                                : item.actionLabel!,
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: palette.primary,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontSize: 12.8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 180),
              sizeCurve: Curves.easeOutCubic,
            ),
          ],
        ),
      ),
    );
  }
}
