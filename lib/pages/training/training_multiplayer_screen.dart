import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/training_tab_body/training_multiplayer_panel.dart';

class TrainingMultiplayerScreen extends StatelessWidget {
  const TrainingMultiplayerScreen({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceContainerHigh,
        elevation: 0,
        leading: BackButton(color: onSurface),
        title: Text(
          'Multiplayer',
          style: GoogleFonts.manrope(
            color: onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
        children: [
          TrainingMultiplayerPanel(
            surfaceContainer: surfaceContainer,
            surfaceContainerHigh: surfaceContainerHigh,
            onSurface: onSurface,
            onSurfaceMuted: onSurfaceMuted,
            primary: primary,
            onCreateRoom: () => Navigator.of(context).pushNamed('multiplayer-create'),
            onJoinWithPin: () => Navigator.of(context).pushNamed('multiplayer-join'),
          ),
        ],
      ),
    );
  }
}
