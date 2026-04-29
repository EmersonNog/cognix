import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlanBillingToggle extends StatelessWidget {
  const PlanBillingToggle({
    super.key,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.selectedBackground,
    required this.selectedForeground,
    required this.selectedPeriod,
    required this.onChanged,
  });

  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color selectedBackground;
  final Color selectedForeground;
  final String selectedPeriod;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged('mensal'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selectedPeriod == 'mensal'
                      ? selectedBackground
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Mensal',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: selectedPeriod == 'mensal'
                        ? selectedForeground
                        : onSurfaceMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged('anual'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selectedPeriod == 'anual'
                      ? selectedBackground
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Anual',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: selectedPeriod == 'anual'
                        ? selectedForeground
                        : onSurfaceMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
