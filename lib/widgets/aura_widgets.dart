import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuraFieldLabel extends StatelessWidget {
  const AuraFieldLabel({
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

class AuraInputField extends StatelessWidget {
  const AuraInputField({
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

class AuraPrimaryButton extends StatelessWidget {
  const AuraPrimaryButton({
    super.key,
    required this.text,
    required this.gradient,
    required this.onPressed,
    this.isLoading = false,
    this.height = 50,
  });

  final String text;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  text,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

class AuraSocialButton extends StatelessWidget {
  const AuraSocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.background,
    required this.textColor,
    this.height = 46,
    this.onPressed,
  });

  final dynamic icon;
  final String label;
  final Color background;
  final Color textColor;
  final double height;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon is IconData)
              Icon(icon as IconData, color: textColor, size: 18)
            else
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  icon.toString(),
                  style: GoogleFonts.plusJakartaSans(
                    color: textColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuraGradientBlob extends StatelessWidget {
  const AuraGradientBlob({
    super.key,
    required this.size,
    required this.colorA,
    required this.colorB,
  });

  final double size;
  final Color colorA;
  final Color colorB;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [colorA, colorB]),
      ),
    );
  }
}

class AuraGlassBadge extends StatelessWidget {
  const AuraGlassBadge({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0x99192540),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(child: child),
    );
  }
}

enum AuraMessageType { info, success, error }

void showAuraMessage(
  BuildContext context,
  String text, {
  AuraMessageType type = AuraMessageType.info,
}) {
  final color = switch (type) {
    AuraMessageType.success => const Color(0xFF7ED6C5),
    AuraMessageType.error => const Color(0xFFEF6A6A),
    AuraMessageType.info => const Color(0xFFA3A6FF),
  };

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 3),
      content: AuraMessageBox(
        text: text,
        accent: color,
        type: type,
      ),
    ),
  );
}

class AuraMessageBox extends StatelessWidget {
  const AuraMessageBox({
    super.key,
    required this.text,
    required this.accent,
    required this.type,
  });

  final String text;
  final Color accent;
  final AuraMessageType type;

  IconData _iconForType() {
    return switch (type) {
      AuraMessageType.success => Icons.check_circle_rounded,
      AuraMessageType.error => Icons.error_rounded,
      AuraMessageType.info => Icons.info_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final shadowColor = accent.withOpacity(0.28);
    final borderColor = accent.withOpacity(0.35);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF172544),
            const Color(0xFF121C33),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_iconForType(), color: accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: const Color(0xFFDEE5FF),
                fontSize: 13.8,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
