import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'plan_button.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.subtitle,
    required this.background,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.features,
    this.primaryDim,
    this.pricePrefix = 'R\$ ',
    this.badge,
    this.footer,
    this.footerPrefix,
    this.footerHighlight,
    this.footerSuffix,
    this.floatingBadge = false,
    this.badgeOffsetY = 0,
    this.buttonLabel = 'Assinar Agora',
    this.buttonStyle = PlanButtonStyle.secondary,
    this.onPressed,
    this.isLoading = false,
    this.isPriceLoading = false,
    this.noticeMessage,
    this.noticeLinkLabel,
    this.onNoticeLinkTap,
    this.noticeColor,
  });

  final String title;
  final String price;
  final String subtitle;
  final Color background;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color? primaryDim;
  final String pricePrefix;
  final List<String> features;
  final String? badge;
  final String? footer;
  final String? footerPrefix;
  final String? footerHighlight;
  final String? footerSuffix;
  final bool floatingBadge;
  final double badgeOffsetY;
  final String buttonLabel;
  final PlanButtonStyle buttonStyle;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPriceLoading;
  final String? noticeMessage;
  final String? noticeLinkLabel;
  final VoidCallback? onNoticeLinkTap;
  final Color? noticeColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (badge != null && !floatingBadge)
                Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(0, badgeOffsetY),
                    child: _buildBadge(),
                  ),
                ),
              if (badge != null && !floatingBadge) const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              if (isPriceLoading)
                _buildPriceLoading()
              else
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.manrope(
                      color: onSurface,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: pricePrefix,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: onSurfaceMuted,
                        ),
                      ),
                      TextSpan(text: price, style: TextStyle(fontSize: 25)),
                      TextSpan(
                        text: subtitle,
                        style: TextStyle(fontSize: 11, color: onSurfaceMuted),
                      ),
                    ],
                  ),
                ),
              if (!isPriceLoading &&
                  (footer != null ||
                      footerPrefix != null ||
                      footerHighlight != null ||
                      footerSuffix != null)) ...[
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      color: onSurfaceMuted,
                      fontSize: 11,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      if (footer != null) TextSpan(text: footer!),
                      if (footerPrefix != null) TextSpan(text: footerPrefix!),
                      if (footerHighlight != null)
                        TextSpan(
                          text: footerHighlight!,
                          style: TextStyle(
                            color: onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      if (footerSuffix != null) TextSpan(text: footerSuffix!),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),
              ...features.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: primary.withValues(alpha: 0.9),
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: GoogleFonts.inter(
                            color: onSurfaceMuted,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              PlanButton(
                label: buttonLabel,
                style: buttonStyle,
                primary: primary,
                primaryDim: primaryDim ?? primary,
                onSurface: onSurface,
                surfaceContainerHigh: surfaceContainerHigh,
                onPressed: onPressed,
                isLoading: isLoading,
              ),
              if (noticeMessage != null &&
                  noticeMessage!.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildNotice(),
              ],
            ],
          ),
        ),
        if (badge != null && floatingBadge)
          Positioned(
            top: badgeOffsetY,
            left: 0,
            right: 0,
            child: Align(alignment: Alignment.center, child: _buildBadge()),
          ),
      ],
    );
  }

  Widget _buildPriceLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(primary),
                backgroundColor: primary.withValues(alpha: 0.14),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Verificando valor',
              style: GoogleFonts.inter(
                color: onSurfaceMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            valueColor: AlwaysStoppedAnimation<Color>(
              primary.withValues(alpha: 0.84),
            ),
            backgroundColor: surfaceContainerHigh,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        badge!,
        style: GoogleFonts.plusJakartaSans(
          color: primary,
          fontSize: 9,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildNotice() {
    final color = noticeColor ?? primary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_rounded, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  color: onSurface,
                  fontSize: 11.2,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(text: noticeMessage!),
                  if (noticeLinkLabel != null &&
                      noticeLinkLabel!.trim().isNotEmpty) ...[
                    const TextSpan(text: ' '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: GestureDetector(
                        onTap: onNoticeLinkTap,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          noticeLinkLabel!,
                          style: GoogleFonts.inter(
                            color: color,
                            fontSize: 11.2,
                            height: 1.35,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline,
                            decorationColor: color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
