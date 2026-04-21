import 'package:flutter/material.dart';

import '../../../theme/theme_mode_picker.dart';
import '../auth_theme.dart';
import 'decorations.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final cardWidth = media.size.width.clamp(0, 420).toDouble();
    final authTheme = AuthTheme.of(context);

    return Scaffold(
      backgroundColor: authTheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -90,
              child: GradientBlob(
                size: 260,
                colorA: authTheme.secondaryDim.withValues(alpha: 0.22),
                colorB: authTheme.primaryDim.withValues(alpha: 0.10),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -110,
              child: GradientBlob(
                size: 320,
                colorA: authTheme.primaryDim.withValues(alpha: 0.18),
                colorB: authTheme.secondaryDim.withValues(alpha: 0.10),
              ),
            ),
            Positioned(
              top: 12,
              right: 16,
              child: ThemeModeQuickButton(
                backgroundColor: authTheme.surfaceHighest,
                iconColor: authTheme.onSurfaceMuted,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardWidth),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      color: authTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: authTheme.cardShadow,
                          blurRadius: 32,
                          offset: const Offset(0, 16),
                        ),
                      ],
                      border: Border.all(
                        color: authTheme.onSurfaceMuted.withValues(alpha: 0.10),
                      ),
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
