part of '../account_security_screen.dart';

extension _AccountSecurityDialogs on _AccountSecurityScreenState {
  Future<bool> _showDeleteConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AccountSecurityPalette.card,
          title: Text(
            'Excluir conta?',
            style: GoogleFonts.manrope(
              color: AccountSecurityPalette.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Ao confirmar, sua conta será encerrada e os dados vinculados a este usuário serão removidos de forma permanente. Essa ação não pode ser desfeita.',
            style: GoogleFonts.inter(
              color: AccountSecurityPalette.onSurfaceMuted,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: AccountSecurityPalette.danger,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
