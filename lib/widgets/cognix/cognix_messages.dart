import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../navigation/app_route_observer.dart';
import '../../theme/cognix_theme_colors.dart';

enum CognixMessageType { info, success, error }

void showCognixMessage(
  BuildContext context,
  String text, {
  CognixMessageType type = CognixMessageType.info,
}) {
  final messenger = ScaffoldMessenger.of(context);
  _showCognixMessageWithMessenger(
    messenger: messenger,
    context: context,
    text: text,
    type: type,
  );
}

void showGlobalCognixMessage(
  String text, {
  CognixMessageType type = CognixMessageType.info,
}) {
  final messenger = appScaffoldMessengerKey.currentState;
  final context = messenger?.context ?? appNavigatorKey.currentContext;
  if (messenger == null || context == null) return;

  _showCognixMessageWithMessenger(
    messenger: messenger,
    context: context,
    text: text,
    type: type,
  );
}

void _showCognixMessageWithMessenger({
  required ScaffoldMessengerState messenger,
  required BuildContext context,
  required String text,
  required CognixMessageType type,
}) {
  final colors = context.cognixColors;
  final color = switch (type) {
    CognixMessageType.success => colors.success,
    CognixMessageType.error => colors.danger,
    CognixMessageType.info => colors.primary,
  };

  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 3),
      content: CognixMessageBox(text: text, accent: color, type: type),
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
    final colors = context.cognixColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = accent.withValues(alpha: isDark ? 0.35 : 0.28);
    final iconBackground = accent.withValues(alpha: isDark ? 0.12 : 0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.surfaceContainerHigh, colors.surfaceContainer],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(_iconForType(), color: accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: colors.onSurface,
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
