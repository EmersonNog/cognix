import 'package:flutter/material.dart';
import '../auth_theme.dart';
import 'decorations.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final cardWidth = media.size.width.clamp(0, 420).toDouble();

    return Scaffold(
      backgroundColor: AuthTheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -90,
              child: GradientBlob(
                size: 260,
                colorA: AuthTheme.secondaryDim.withOpacity(0.35),
                colorB: AuthTheme.primaryDim.withOpacity(0.15),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -110,
              child: GradientBlob(
                size: 320,
                colorA: AuthTheme.primaryDim.withOpacity(0.22),
                colorB: AuthTheme.secondaryDim.withOpacity(0.12),
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
                      color: AuthTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AuthTheme.onSurface.withOpacity(0.06),
                          blurRadius: 32,
                          offset: const Offset(0, 16),
                        ),
                      ],
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
