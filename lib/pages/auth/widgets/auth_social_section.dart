import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth_theme.dart';
import 'primary_buttons.dart';

class AuthSocialSection extends StatelessWidget {
  const AuthSocialSection({
    super.key,
    required this.title,
    required this.onGooglePressed,
  });

  final String title;
  final VoidCallback onGooglePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              color: AuthTheme.onSurfaceMuted.withOpacity(0.7),
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CognixSocialButton(
                icon: 'G',
                label: 'Google',
                background: AuthTheme.surfaceHighest,
                textColor: AuthTheme.onSurface,
                onPressed: onGooglePressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
