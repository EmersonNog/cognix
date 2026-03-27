import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CognixTopBar extends StatelessWidget {
  const CognixTopBar({
    super.key,
    required this.title,
    required this.containerColor,
    required this.titleColor,
    this.leadingIcon = Icons.school_rounded,
    this.leadingColor = const Color(0xFFA3A6FF),
    this.leadingBackground,
    this.trailing,
  });

  final String title;
  final Color containerColor;
  final Color titleColor;
  final IconData leadingIcon;
  final Color leadingColor;
  final Color? leadingBackground;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: leadingBackground ?? containerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(leadingIcon, color: leadingColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.manrope(
                color: titleColor,
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
