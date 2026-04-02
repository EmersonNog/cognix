import 'package:flutter/material.dart';

class HomePerformanceCtaCard extends StatelessWidget {
  const HomePerformanceCtaCard({
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
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Color.alphaBlend(
            primary.withOpacity(0.05),
            const Color(0xFF101936),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.insights_rounded,
                color: primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'ANÁLISE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Análise de desempenho',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: onSurface.withOpacity(0.94),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Veja seus sinais mais importantes em uma leitura rápida.',
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
              color: onSurfaceMuted,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
