part of '../subjects_tab.dart';

class _LoadingState extends StatelessWidget {
  const _LoadingState({
    required this.surfaceContainer,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: surfaceContainer,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(primary),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Carregando disciplinas...',
              style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onSurfaceMuted});

  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        'Nenhuma disciplina encontrada.',
        style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12.5),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onSurfaceMuted});

  final String message;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12.5),
        textAlign: TextAlign.center,
      ),
    );
  }
}
