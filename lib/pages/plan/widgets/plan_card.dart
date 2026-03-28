import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'plan_button.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.background,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.features,
    this.primaryDim,
    this.badge,
    this.footer,
    this.buttonStyle = PlanButtonStyle.secondary,
  });

  final String title;
  final String price;
  final String subtitle;
  final Color background;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color? primaryDim;
  final List<String> features;
  final String? badge;
  final String? footer;
  final PlanButtonStyle buttonStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge != null)
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.18),
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
              ),
            ),
          if (badge != null) const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.manrope(
              color: onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: GoogleFonts.manrope(
                color: onSurface,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
              children: [
                TextSpan(
                  text: 'R\$ ',
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
          if (footer != null) ...[
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: GoogleFonts.plusJakartaSans(
                  color: onSurfaceMuted,
                  fontSize: 9.5,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                ),
                children: [
                  TextSpan(text: 'TOTAL '),
                  TextSpan(
                    text: 'R\$ ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '239,40'),
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
                    color: primary.withOpacity(0.9),
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
            label: 'Assinar Agora',
            style: buttonStyle,
            primary: primary,
            primaryDim: primaryDim ?? primary,
            onSurface: onSurface,
            surfaceContainerHigh: const Color(0xFF141F38),
          ),
        ],
      ),
    );
  }
}
