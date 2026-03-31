import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'subjects_data.dart';
import 'subjects_tab.dart';

class SubjectsAreaScreen extends StatelessWidget {
  const SubjectsAreaScreen({
    super.key,
    required this.area,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final SubjectsArea area;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060E20),
      appBar: AppBar(
        title: Text(
          'Exercícios',
          style: GoogleFonts.manrope(
            color: onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: surfaceContainerHigh,
        elevation: 0,
        leading: BackButton(color: onSurface),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SubjectsTab(
          area: area,
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
      ),
    );
  }
}
