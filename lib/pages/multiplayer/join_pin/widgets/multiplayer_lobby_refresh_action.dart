import 'package:flutter/material.dart';

import '../../shared/widgets/palette.dart';

class MultiplayerLobbyRefreshAction extends StatelessWidget {
  const MultiplayerLobbyRefreshAction({
    super.key,
    required this.palette,
    required this.isRefreshing,
    required this.enabled,
    required this.onRefresh,
  });

  final MultiplayerPalette palette;
  final bool isRefreshing;
  final bool enabled;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = enabled ? palette.primary : palette.onSurfaceMuted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled && !isRefreshing ? onRefresh : null,
        borderRadius: BorderRadius.circular(15),
        child: Tooltip(
          message: isRefreshing ? 'Atualizando...' : 'Atualizar sala',
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: palette.primary.withValues(alpha: enabled ? 0.13 : 0.07),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: isRefreshing
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: palette.primary,
                      ),
                    )
                  : Icon(
                      Icons.refresh_rounded,
                      color: foregroundColor,
                      size: 22,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
