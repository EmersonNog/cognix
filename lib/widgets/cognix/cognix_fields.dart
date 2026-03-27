import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CognixFieldLabel extends StatelessWidget {
  const CognixFieldLabel({
    super.key,
    required this.text,
    this.color = const Color(0xFF9AA6C5),
    this.fontSize = 11.5,
    this.letterSpacing = 1.4,
    this.fontWeight = FontWeight.w600,
  });

  final String text;
  final Color color;
  final double fontSize;
  final double letterSpacing;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        color: color,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
      ),
    );
  }
}

class CognixInputField extends StatelessWidget {
  const CognixInputField({
    super.key,
    required this.focusNode,
    required this.hintText,
    required this.icon,
    required this.background,
    required this.primary,
    this.controller,
    this.obscure = false,
    this.suffix,
  });

  final FocusNode focusNode;
  final String hintText;
  final IconData icon;
  final Color background;
  final Color primary;
  final TextEditingController? controller;
  final bool obscure;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                        color: primary.withOpacity(0.25),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
              border: isFocused
                  ? Border.all(color: primary.withOpacity(0.4), width: 1)
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF9AA6C5), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    obscureText: obscure,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFDEE5FF),
                      fontSize: 14.5,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: GoogleFonts.inter(
                        color: const Color(0xFF66708A),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (suffix != null) suffix!,
              ],
            ),
          );
        },
      ),
    );
  }
}
