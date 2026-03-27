import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CognixMessageType { info, success, error }

void showCognixMessage(
  BuildContext context,
  String text, {
  CognixMessageType type = CognixMessageType.info,
}) {
  final color = switch (type) {
    CognixMessageType.success => const Color(0xFF7ED6C5),
    CognixMessageType.error => const Color(0xFFEF6A6A),
    CognixMessageType.info => const Color(0xFFA3A6FF),
  };

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 3),
      content: CognixMessageBox(
        text: text,
        accent: color,
        type: type,
      ),
    ),
  );
}

class CognixMessageBox extends StatelessWidget {
  const CognixMessageBox({
    super.key,
    required this.text,
    required this.accent,
    required this.type,
  });

  final String text;
  final Color accent;
  final CognixMessageType type;

  IconData _iconForType() {
    return switch (type) {
      CognixMessageType.success => Icons.check_circle_rounded,
      CognixMessageType.error => Icons.error_rounded,
      CognixMessageType.info => Icons.info_rounded,
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
