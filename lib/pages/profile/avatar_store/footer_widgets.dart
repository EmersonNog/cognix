part of '../avatar_store_dialog.dart';

class _AvatarStoreFooter extends StatelessWidget {
  const _AvatarStoreFooter({
    required this.onSurface,
    required this.isSubmitting,
    required this.canSubmit,
    required this.primaryActionColor,
    required this.primaryActionLabel,
    required this.primaryActionIcon,
    required this.onClose,
    required this.onSubmit,
  });

  final Color onSurface;
  final bool isSubmitting;
  final bool canSubmit;
  final Color primaryActionColor;
  final String primaryActionLabel;
  final IconData primaryActionIcon;
  final VoidCallback onClose;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF141E39),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              onPressed: isSubmitting ? null : onClose,
              style: OutlinedButton.styleFrom(
                foregroundColor: onSurface,
                backgroundColor: const Color(0xFF18223D),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
                minimumSize: const Size.fromHeight(50),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: onSurface.withValues(alpha: 0.92),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Fechar',
                    style: GoogleFonts.manrope(
                      color: onSurface.withValues(alpha: 0.94),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: canSubmit ? onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryActionColor,
                disabledBackgroundColor: primaryActionColor.withValues(
                  alpha: 0.55,
                ),
                elevation: 0,
                minimumSize: const Size.fromHeight(50),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(primaryActionIcon, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      primaryActionLabel,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
