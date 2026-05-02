part of '../writing_editor_screen.dart';

extension _WritingEditorLoadingFlow on _WritingEditorScreenState {
  Future<T> _runWithAiLoading<T>({
    required String title,
    required String subtitle,
    required List<String> steps,
    required Future<T> Function() action,
  }) async {
    if (!mounted) {
      return action();
    }

    final navigator = Navigator.of(context, rootNavigator: true);
    var isLoadingRouteOpen = true;
    final loadingFuture = showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Carregando',
      barrierColor: Colors.black.withValues(alpha: 0.72),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, _, _) {
        return PopScope(
          canPop: false,
          child: _WritingAiLoadingScreen(
            title: title,
            subtitle: subtitle,
            steps: steps,
          ),
        );
      },
      transitionBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.97, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    ).whenComplete(() => isLoadingRouteOpen = false);

    await Future<void>.delayed(const Duration(milliseconds: 120));
    try {
      return await action();
    } finally {
      if (isLoadingRouteOpen && navigator.mounted) {
        navigator.pop();
      }
      await loadingFuture;
    }
  }
}
