import 'package:flutter/material.dart';

class ProfileOpenPanelCard extends StatelessWidget {
  const ProfileOpenPanelCard({
    super.key,
    required this.onTap,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final VoidCallback onTap;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF141E39),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.dashboard_customize_rounded,
                color: primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Abrir painel completo',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Veja consistência, planos, desempenho detalhado e atalhos da sua conta em uma tela separada.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: onSurfaceMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: onSurfaceMuted,
            ),
          ],
        ),
      ),
    );
  }
}
