import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingSessionLoadingState extends StatelessWidget {
  const TrainingSessionLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class TrainingSessionRestoringState extends StatelessWidget {
  const TrainingSessionRestoringState({
    super.key,
    required this.onSurfaceMuted,
  });

  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Restaurando simulado...',
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class TrainingSessionMessageState extends StatelessWidget {
  const TrainingSessionMessageState({
    super.key,
    required this.message,
    required this.onSurfaceMuted,
  });

  final String message;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          message,
          style: GoogleFonts.inter(
            color: onSurfaceMuted,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
