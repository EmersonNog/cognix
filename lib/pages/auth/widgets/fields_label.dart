import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel({
    super.key,
    required this.text,
    this.color,
    this.fontSize = 11.5,
    this.letterSpacing = 1.4,
    this.fontWeight = FontWeight.w600,
  });

  final String text;
  final Color? color;
  final double fontSize;
  final double letterSpacing;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final resolvedColor =
        color ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        color: resolvedColor,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
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
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onSurfaceVariant;
    final textColor = theme.colorScheme.onSurface;
    final hintColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: 0.82,
    );
    final borderColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: 0.14,
    );

    return Focus(
      focusNode: focusNode,
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(18),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.16),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
              border: Border.all(
                color: isFocused
                    ? primary.withValues(alpha: 0.42)
                    : borderColor,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    obscureText: obscure,
                    style: GoogleFonts.inter(color: textColor, fontSize: 14.5),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: false,
                      hintText: hintText,
                      hintStyle: GoogleFonts.inter(
                        color: hintColor,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
