import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/widgets/fields_label.dart';
import '../../auth/widgets/primary_buttons.dart';
import 'account_security_expandable_card.dart';
import 'account_security_palette.dart';

class AccountSecurityDeleteAccountPanel extends StatelessWidget {
  const AccountSecurityDeleteAccountPanel({
    super.key,
    required this.isExpanded,
    required this.supportsPasswordProvider,
    required this.supportsGoogleProvider,
    required this.isDeletingAccount,
    required this.obscureDeletePassword,
    required this.deleteConfirmationController,
    required this.deletePasswordController,
    required this.deleteConfirmationFocus,
    required this.deletePasswordFocus,
    required this.onToggle,
    required this.onToggleDeletePasswordVisibility,
    required this.onSubmit,
  });

  final bool isExpanded;
  final bool supportsPasswordProvider;
  final bool supportsGoogleProvider;
  final bool isDeletingAccount;
  final bool obscureDeletePassword;
  final TextEditingController deleteConfirmationController;
  final TextEditingController deletePasswordController;
  final FocusNode deleteConfirmationFocus;
  final FocusNode deletePasswordFocus;
  final VoidCallback onToggle;
  final VoidCallback onToggleDeletePasswordVisibility;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return AccountSecurityExpandableCard(
      title: 'Excluir conta',
      subtitle: isExpanded
          ? 'Toque para recolher os detalhes da exclusão'
          : 'Toque para revisar o impacto e confirmar a exclusão definitiva',
      accent: AccountSecurityPalette.danger,
      borderColor: AccountSecurityPalette.danger.withValues(alpha: 0.22),
      isExpanded: isExpanded,
      onToggle: onToggle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Esse processo remove seu acesso e limpa o histórico associado ao usuário.',
            style: GoogleFonts.inter(
              color: AccountSecurityPalette.onSurfaceMuted,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const _AccountDangerBullet(
            text: 'encerra de forma permanente o acesso desta conta ao app',
          ),
          const _AccountDangerBullet(
            text: 'remove o histórico e os dados vinculados a este usuário',
          ),
          const _AccountDangerBullet(
            text: 'desconecta você imediatamente deste dispositivo',
          ),
          const SizedBox(height: 18),
          const FieldLabel(text: 'DIGITE EXCLUIR PARA CONFIRMAR'),
          const SizedBox(height: 8),
          InputField(
            controller: deleteConfirmationController,
            focusNode: deleteConfirmationFocus,
            hintText: 'EXCLUIR',
            icon: Icons.warning_amber_rounded,
            background: AccountSecurityPalette.cardSoft,
            primary: AccountSecurityPalette.danger,
          ),
          if (supportsPasswordProvider) ...[
            const SizedBox(height: 16),
            const FieldLabel(text: 'CONFIRME SUA SENHA ATUAL'),
            const SizedBox(height: 8),
            InputField(
              controller: deletePasswordController,
              focusNode: deletePasswordFocus,
              hintText: '********',
              icon: Icons.lock_outline_rounded,
              background: AccountSecurityPalette.cardSoft,
              primary: AccountSecurityPalette.danger,
              obscure: obscureDeletePassword,
              suffix: IconButton(
                onPressed: onToggleDeletePasswordVisibility,
                icon: Icon(
                  obscureDeletePassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: AccountSecurityPalette.onSurfaceMuted,
                  size: 20,
                ),
              ),
            ),
          ] else if (supportsGoogleProvider) ...[
            const SizedBox(height: 16),
            Text(
              'Ao confirmar, você tambem vai validar sua conta Google para concluir a exclusão.',
              style: GoogleFonts.inter(
                color: AccountSecurityPalette.onSurfaceMuted,
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 18),
          PrimaryButton(
            text: 'Excluir minha conta',
            gradient: const LinearGradient(
              colors: [Color(0xFFFF7B7B), Color(0xFFD94E4E)],
            ),
            onPressed: onSubmit,
            isLoading: isDeletingAccount,
          ),
        ],
      ),
    );
  }
}

class _AccountDangerBullet extends StatelessWidget {
  const _AccountDangerBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.circle,
              size: 8,
              color: AccountSecurityPalette.dangerSoft,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: AccountSecurityPalette.onSurfaceMuted,
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
