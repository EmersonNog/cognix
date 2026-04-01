import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth_theme.dart';

class AuthInlinePrompt extends StatelessWidget {
  const AuthInlinePrompt({
    super.key,
    required this.prefix,
    required this.actionLabel,
    required this.onTap,
  });

  final String prefix;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            prefix,
            style: GoogleFonts.inter(
              color: AuthTheme.onSurfaceMuted,
              fontSize: 12.5,
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: AuthTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
