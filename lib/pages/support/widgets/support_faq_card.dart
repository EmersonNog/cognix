import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'support_palette.dart';

class SupportFaqCard extends StatelessWidget {
  const SupportFaqCard({super.key, required this.item});

  final SupportFaqItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: supportCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          iconColor: supportOnSurfaceMuted,
          collapsedIconColor: supportOnSurfaceMuted,
          title: Text(
            item.question,
            style: GoogleFonts.manrope(
              color: supportOnSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.answer,
                style: GoogleFonts.inter(
                  color: supportOnSurfaceMuted,
                  fontSize: 12.5,
                  height: 1.55,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupportFaqItem {
  const SupportFaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}
